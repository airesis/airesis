/**
 * Rangy, a cross-browser JavaScript range and selection library
 * http://code.google.com/p/rangy/
 *
 * Copyright 2014, Tim Down
 * Licensed under the MIT license.
 * Version: 1.3alpha.20140716
 * Build date: 16 July 2014
 */

(function(global) {
	var amdSupported = (typeof global.define == "function" && global.define.amd);

	var OBJECT = "object", FUNCTION = "function", UNDEFINED = "undefined";

	// Minimal set of properties required for DOM Level 2 Range compliance. Comparison constants such as START_TO_START
	// are omitted because ranges in KHTML do not have them but otherwise work perfectly well. See issue 113.
	var domRangeProperties = ["startContainer", "startOffset", "endContainer", "endOffset", "collapsed",
		"commonAncestorContainer"];

	// Minimal set of methods required for DOM Level 2 Range compliance
	var domRangeMethods = ["setStart", "setStartBefore", "setStartAfter", "setEnd", "setEndBefore",
		"setEndAfter", "collapse", "selectNode", "selectNodeContents", "compareBoundaryPoints", "deleteContents",
		"extractContents", "cloneContents", "insertNode", "surroundContents", "cloneRange", "toString", "detach"];

	var textRangeProperties = ["boundingHeight", "boundingLeft", "boundingTop", "boundingWidth", "htmlText", "text"];

	// Subset of TextRange's full set of methods that we're interested in
	var textRangeMethods = ["collapse", "compareEndPoints", "duplicate", "moveToElementText", "parentElement", "select",
		"setEndPoint", "getBoundingClientRect"];

	/*----------------------------------------------------------------------------------------------------------------*/

	// Trio of functions taken from Peter Michaux's article:
	// http://peter.michaux.ca/articles/feature-detection-state-of-the-art-browser-scripting
	function isHostMethod(o, p) {
		var t = typeof o[p];
		return t == FUNCTION || (!!(t == OBJECT && o[p])) || t == "unknown";
	}

	function isHostObject(o, p) {
		return !!(typeof o[p] == OBJECT && o[p]);
	}

	function isHostProperty(o, p) {
		return typeof o[p] != UNDEFINED;
	}

	// Creates a convenience function to save verbose repeated calls to tests functions
	function createMultiplePropertyTest(testFunc) {
		return function(o, props) {
			var i = props.length;
			while (i--) {
				if (!testFunc(o, props[i])) {
					return false;
				}
			}
			return true;
		};
	}

	// Next trio of functions are a convenience to save verbose repeated calls to previous two functions
	var areHostMethods = createMultiplePropertyTest(isHostMethod);
	var areHostObjects = createMultiplePropertyTest(isHostObject);
	var areHostProperties = createMultiplePropertyTest(isHostProperty);

	function isTextRange(range) {
		return range && areHostMethods(range, textRangeMethods) && areHostProperties(range, textRangeProperties);
	}

	function getBody(doc) {
		return isHostObject(doc, "body") ? doc.body : doc.getElementsByTagName("body")[0];
	}

	var modules = {};

	var api = {
        version: "1.3alpha.20140716",
		initialized: false,
		supported: true,

		util: {
			isHostMethod: isHostMethod,
			isHostObject: isHostObject,
			isHostProperty: isHostProperty,
			areHostMethods: areHostMethods,
			areHostObjects: areHostObjects,
			areHostProperties: areHostProperties,
			isTextRange: isTextRange,
			getBody: getBody
		},

		features: {},

		modules: modules,
		config: {
			alertOnFail: true,
			alertOnWarn: false,
			preferTextRange: false
		}
	};

	function consoleLog(msg) {
		if (isHostObject(window, "console") && isHostMethod(window.console, "log")) {
			window.console.log(msg);
		}
	}

	function alertOrLog(msg, shouldAlert) {
		if (shouldAlert) {
			window.alert(msg);
		} else  {
			consoleLog(msg);
		}
	}

	function fail(reason) {
		api.initialized = true;
		api.supported = false;
		alertOrLog("Rangy is not supported on this page in your browser. Reason: " + reason, api.config.alertOnFail);
	}

	api.fail = fail;

	function warn(msg) {
		alertOrLog("Rangy warning: " + msg, api.config.alertOnWarn);
	}

	api.warn = warn;

	// Add utility extend() method
	if ({}.hasOwnProperty) {
		api.util.extend = function(obj, props, deep) {
			var o, p;
			for (var i in props) {
				if (props.hasOwnProperty(i)) {
					o = obj[i];
					p = props[i];
					if (deep && o !== null && typeof o == "object" && p !== null && typeof p == "object") {
						api.util.extend(o, p, true);
				}
					obj[i] = p;
			}
			}
            // Special case for toString, which does not show up in for...in loops in IE <= 8
            if (props.hasOwnProperty("toString")) {
                obj.toString = props.toString;
            }
			return obj;
		};
	} else {
		fail("hasOwnProperty not supported");
	}

	// Test whether Array.prototype.slice can be relied on for NodeLists and use an alternative toArray() if not
	(function() {
		var el = document.createElement("div");
		el.appendChild(document.createElement("span"));
		var slice = [].slice;
		var toArray;
		try {
			if (slice.call(el.childNodes, 0)[0].nodeType == 1) {
				toArray = function(arrayLike) {
					return slice.call(arrayLike, 0);
				};
			}
		} catch (e) {}

		if (!toArray) {
			toArray = function(arrayLike) {
				var arr = [];
				for (var i = 0, len = arrayLike.length; i < len; ++i) {
					arr[i] = arrayLike[i];
				}
				return arr;
			};
		}

		api.util.toArray = toArray;
	})();


	// Very simple event handler wrapper function that doesn't attempt to solve issues such as "this" handling or
	// normalization of event properties
	var addListener;
	if (isHostMethod(document, "addEventListener")) {
		addListener = function(obj, eventType, listener) {
			obj.addEventListener(eventType, listener, false);
		};
	} else if (isHostMethod(document, "attachEvent")) {
		addListener = function(obj, eventType, listener) {
			obj.attachEvent("on" + eventType, listener);
		};
	} else {
		fail("Document does not have required addEventListener or attachEvent method");
	}

	api.util.addListener = addListener;

	var initListeners = [];

	function getErrorDesc(ex) {
		return ex.message || ex.description || String(ex);
	}

	// Initialization
	function init() {
		if (api.initialized) {
			return;
		}
		var testRange;
		var implementsDomRange = false, implementsTextRange = false;

		// First, perform basic feature tests

		if (isHostMethod(document, "createRange")) {
			testRange = document.createRange();
			if (areHostMethods(testRange, domRangeMethods) && areHostProperties(testRange, domRangeProperties)) {
				implementsDomRange = true;
			}
		}

		var body = getBody(document);
		if (!body || body.nodeName.toLowerCase() != "body") {
			fail("No body element found");
			return;
		}

		if (body && isHostMethod(body, "createTextRange")) {
			testRange = body.createTextRange();
			if (isTextRange(testRange)) {
				implementsTextRange = true;
			}
		}

		if (!implementsDomRange && !implementsTextRange) {
			fail("Neither Range nor TextRange are available");
			return;
		}

		api.initialized = true;
		api.features = {
			implementsDomRange: implementsDomRange,
			implementsTextRange: implementsTextRange
		};

		// Initialize modules
		var module, errorMessage;
		for (var moduleName in modules) {
			if ( (module = modules[moduleName]) instanceof Module ) {
				module.init(module, api);
			}
		}

		// Call init listeners
		for (var i = 0, len = initListeners.length; i < len; ++i) {
			try {
				initListeners[i](api);
			} catch (ex) {
				errorMessage = "Rangy init listener threw an exception. Continuing. Detail: " + getErrorDesc(ex);
				consoleLog(errorMessage);
			}
		}
	}

	// Allow external scripts to initialize this library in case it's loaded after the document has loaded
	api.init = init;

	// Execute listener immediately if already initialized
	api.addInitListener = function(listener) {
		if (api.initialized) {
			listener(api);
		} else {
			initListeners.push(listener);
		}
	};

	var createMissingNativeApiListeners = [];

	api.addCreateMissingNativeApiListener = function(listener) {
		createMissingNativeApiListeners.push(listener);
	};

	function createMissingNativeApi(win) {
		win = win || window;
		init();

		// Notify listeners
		for (var i = 0, len = createMissingNativeApiListeners.length; i < len; ++i) {
			createMissingNativeApiListeners[i](win);
		}
	}

	api.createMissingNativeApi = createMissingNativeApi;

	function Module(name, dependencies, initializer) {
		this.name = name;
		this.dependencies = dependencies;
		this.initialized = false;
		this.supported = false;
		this.initializer = initializer;
	}

	Module.prototype = {
		init: function(api) {
			var requiredModuleNames = this.dependencies || [];
			for (var i = 0, len = requiredModuleNames.length, requiredModule, moduleName; i < len; ++i) {
				moduleName = requiredModuleNames[i];

				requiredModule = modules[moduleName];
				if (!requiredModule || !(requiredModule instanceof Module)) {
					throw new Error("required module '" + moduleName + "' not found");
				}

				requiredModule.init();

				if (!requiredModule.supported) {
					throw new Error("required module '" + moduleName + "' not supported");
				}
			}
			
			// Now run initializer
            this.initializer(this);
		},
		
		fail: function(reason) {
		this.initialized = true;
		this.supported = false;
		throw new Error("Module '" + this.name + "' failed to load: " + reason);
		},

		warn: function(msg) {
		api.warn("Module " + this.name + ": " + msg);
		},

		deprecationNotice: function(deprecated, replacement) {
            api.warn("DEPRECATED: " + deprecated + " in module " + this.name + "is deprecated. Please use " +
                replacement + " instead");
		},

		createError: function(msg) {
		return new Error("Error in Rangy " + this.name + " module: " + msg);
		}
	};

	function createModule(isCore, name, dependencies, initFunc) {
		var newModule = new Module(name, dependencies, function(module) {
			if (!module.initialized) {
				module.initialized = true;
				try {
			initFunc(api, module);
			module.supported = true;
				} catch (ex) {
					var errorMessage = "Module '" + name + "' failed to load: " + getErrorDesc(ex);
					consoleLog(errorMessage);
				}
			}
		});
		modules[name] = newModule;
		
/*
		// Add module AMD support
		if (!isCore && amdSupported) {
			global.define(["rangy-core"], function(rangy) {

			});
			}
*/
			}

	api.createModule = function(name) {
		// Allow 2 or 3 arguments (second argument is an optional array of dependencies)
		var initFunc, dependencies;
		if (arguments.length == 2) {
			initFunc = arguments[1];
			dependencies = [];
		} else {
			initFunc = arguments[2];
			dependencies = arguments[1];
		}
		createModule(false, name, dependencies, initFunc);
	};

	api.createCoreModule = function(name, dependencies, initFunc) {
		createModule(true, name, dependencies, initFunc);
	};

	/*----------------------------------------------------------------------------------------------------------------*/

	// Ensure rangy.rangePrototype and rangy.selectionPrototype are available immediately

	function RangePrototype() {}
	api.RangePrototype = RangePrototype;
	api.rangePrototype = new RangePrototype();

	function SelectionPrototype() {}
	api.selectionPrototype = new SelectionPrototype();

	/*----------------------------------------------------------------------------------------------------------------*/

	// Wait for document to load before running tests

	var docReady = false;

	var loadHandler = function(e) {
		if (!docReady) {
			docReady = true;
			if (!api.initialized) {
				init();
			}
		}
	};

	// Test whether we have window and document objects that we will need
	if (typeof window == UNDEFINED) {
		fail("No window found");
		return;
	}
	if (typeof document == UNDEFINED) {
		fail("No document found");
		return;
	}

	if (isHostMethod(document, "addEventListener")) {
		document.addEventListener("DOMContentLoaded", loadHandler, false);
	}

	// Add a fallback in case the DOMContentLoaded event isn't supported
	addListener(window, "load", loadHandler);

	/*----------------------------------------------------------------------------------------------------------------*/
	
    // AMD support, for those who like that kind of thing.
	if (amdSupported) {
        /**
         * Register Rangy as an anonymous module.
         * 
         * According to the AMD docs (https://github.com/amdjs/amdjs-api/wiki/AMD#usage-notes-):
         * "It is recommended that define calls be in the literal form of 'define(...)' in
         * order to work properly with static analysis tools (like build tools).".
         * See also Rangy issue #204 (https://github.com/timdown/rangy/issues/204).
         * 
         * We therefore dutifully jump through this little hoop.
         */
        (function(define) {
            define(function() {
			api.amd = true;
			return api;
		});
        })(global.define);
	}

	// Create a "rangy" property of the global object in any case. Other Rangy modules (which use Rangy's own simple
	// module system) rely on the existence of this global property
	global.rangy = api;
})(this);	

rangy.createCoreModule("DomUtil", [], function(api, module) {
	var UNDEF = "undefined";
	var util = api.util;

	// Perform feature tests
	if (!util.areHostMethods(document, ["createDocumentFragment", "createElement", "createTextNode"])) {
		module.fail("document missing a Node creation method");
	}

	if (!util.isHostMethod(document, "getElementsByTagName")) {
		module.fail("document missing getElementsByTagName method");
	}

	var el = document.createElement("div");
	if (!util.areHostMethods(el, ["insertBefore", "appendChild", "cloneNode"] ||
			!util.areHostObjects(el, ["previousSibling", "nextSibling", "childNodes", "parentNode"]))) {
		module.fail("Incomplete Element implementation");
	}

	// innerHTML is required for Range's createContextualFragment method
	if (!util.isHostProperty(el, "innerHTML")) {
		module.fail("Element is missing innerHTML property");
	}

	var textNode = document.createTextNode("test");
	if (!util.areHostMethods(textNode, ["splitText", "deleteData", "insertData", "appendData", "cloneNode"] ||
			!util.areHostObjects(el, ["previousSibling", "nextSibling", "childNodes", "parentNode"]) ||
			!util.areHostProperties(textNode, ["data"]))) {
		module.fail("Incomplete Text Node implementation");
	}

	/*----------------------------------------------------------------------------------------------------------------*/

	// Removed use of indexOf because of a bizarre bug in Opera that is thrown in one of the Acid3 tests. I haven't been
	// able to replicate it outside of the test. The bug is that indexOf returns -1 when called on an Array that
	// contains just the document as a single element and the value searched for is the document.
	var arrayContains = /*Array.prototype.indexOf ?
		function(arr, val) {
			return arr.indexOf(val) > -1;
		}:*/

		function(arr, val) {
			var i = arr.length;
			while (i--) {
				if (arr[i] === val) {
					return true;
				}
			}
			return false;
		};

	// Opera 11 puts HTML elements in the null namespace, it seems, and IE 7 has undefined namespaceURI
	function isHtmlNamespace(node) {
		var ns;
		return typeof node.namespaceURI == UNDEF || ((ns = node.namespaceURI) === null || ns == "http://www.w3.org/1999/xhtml");
	}

	function parentElement(node) {
		var parent = node.parentNode;
		return (parent.nodeType == 1) ? parent : null;
	}

	function getNodeIndex(node) {
		var i = 0;
		while( (node = node.previousSibling) ) {
			++i;
		}
		return i;
	}

	function getNodeLength(node) {
		switch (node.nodeType) {
			case 7:
			case 10:
				return 0;
			case 3:
			case 8:
				return node.length;
			default:
				return node.childNodes.length;
		}
	}

	function getCommonAncestor(node1, node2) {
		var ancestors = [], n;
		for (n = node1; n; n = n.parentNode) {
			ancestors.push(n);
		}

		for (n = node2; n; n = n.parentNode) {
			if (arrayContains(ancestors, n)) {
				return n;
			}
		}

		return null;
	}

	function isAncestorOf(ancestor, descendant, selfIsAncestor) {
		var n = selfIsAncestor ? descendant : descendant.parentNode;
		while (n) {
			if (n === ancestor) {
				return true;
			} else {
				n = n.parentNode;
			}
		}
		return false;
	}

	function isOrIsAncestorOf(ancestor, descendant) {
		return isAncestorOf(ancestor, descendant, true);
	}

	function getClosestAncestorIn(node, ancestor, selfIsAncestor) {
		var p, n = selfIsAncestor ? node : node.parentNode;
		while (n) {
			p = n.parentNode;
			if (p === ancestor) {
				return n;
			}
			n = p;
		}
		return null;
	}

	function isCharacterDataNode(node) {
		var t = node.nodeType;
		return t == 3 || t == 4 || t == 8 ; // Text, CDataSection or Comment
	}

	function isTextOrCommentNode(node) {
		if (!node) {
			return false;
		}
		var t = node.nodeType;
		return t == 3 || t == 8 ; // Text or Comment
	}

	function insertAfter(node, precedingNode) {
		var nextNode = precedingNode.nextSibling, parent = precedingNode.parentNode;
		if (nextNode) {
			parent.insertBefore(node, nextNode);
		} else {
			parent.appendChild(node);
		}
		return node;
	}

	// Note that we cannot use splitText() because it is bugridden in IE 9.
	function splitDataNode(node, index, positionsToPreserve) {
		var newNode = node.cloneNode(false);
		newNode.deleteData(0, index);
		node.deleteData(index, node.length - index);
		insertAfter(newNode, node);

		// Preserve positions
		if (positionsToPreserve) {
			for (var i = 0, position; position = positionsToPreserve[i++]; ) {
				// Handle case where position was inside the portion of node after the split point
				if (position.node == node && position.offset > index) {
					position.node = newNode;
					position.offset -= index;
				}
				// Handle the case where the position is a node offset within node's parent
				else if (position.node == node.parentNode && position.offset > getNodeIndex(node)) {
					++position.offset;
				}
			}
		}
		return newNode;
	}

	function getDocument(node) {
		if (node.nodeType == 9) {
			return node;
		} else if (typeof node.ownerDocument != UNDEF) {
			return node.ownerDocument;
		} else if (typeof node.document != UNDEF) {
			return node.document;
		} else if (node.parentNode) {
			return getDocument(node.parentNode);
		} else {
			throw module.createError("getDocument: no document found for node");
		}
	}

	function getWindow(node) {
		var doc = getDocument(node);
		if (typeof doc.defaultView != UNDEF) {
			return doc.defaultView;
		} else if (typeof doc.parentWindow != UNDEF) {
			return doc.parentWindow;
		} else {
			throw module.createError("Cannot get a window object for node");
		}
	}

	function getIframeDocument(iframeEl) {
		if (typeof iframeEl.contentDocument != UNDEF) {
			return iframeEl.contentDocument;
		} else if (typeof iframeEl.contentWindow != UNDEF) {
			return iframeEl.contentWindow.document;
		} else {
			throw module.createError("getIframeDocument: No Document object found for iframe element");
		}
	}

	function getIframeWindow(iframeEl) {
		if (typeof iframeEl.contentWindow != UNDEF) {
			return iframeEl.contentWindow;
		} else if (typeof iframeEl.contentDocument != UNDEF) {
			return iframeEl.contentDocument.defaultView;
		} else {
			throw module.createError("getIframeWindow: No Window object found for iframe element");
		}
	}

	// This looks bad. Is it worth it?
	function isWindow(obj) {
		return obj && util.isHostMethod(obj, "setTimeout") && util.isHostObject(obj, "document");
	}

	function getContentDocument(obj, module, methodName) {
		var doc;

		if (!obj) {
			doc = document;
		}

		// Test if a DOM node has been passed and obtain a document object for it if so
		else if (util.isHostProperty(obj, "nodeType")) {
            doc = (obj.nodeType == 1 && obj.tagName.toLowerCase() == "iframe") ?
                getIframeDocument(obj) : getDocument(obj);
		}

		// Test if the doc parameter appears to be a Window object
		else if (isWindow(obj)) {
			doc = obj.document;
		}

		if (!doc) {
			throw module.createError(methodName + "(): Parameter must be a Window object or DOM node");
		}

		return doc;
	}

	function getRootContainer(node) {
		var parent;
		while ( (parent = node.parentNode) ) {
			node = parent;
		}
		return node;
	}

	function comparePoints(nodeA, offsetA, nodeB, offsetB) {
		// See http://www.w3.org/TR/DOM-Level-2-Traversal-Range/ranges.html#Level-2-Range-Comparing
		var nodeC, root, childA, childB, n;
		if (nodeA == nodeB) {
			// Case 1: nodes are the same
			return offsetA === offsetB ? 0 : (offsetA < offsetB) ? -1 : 1;
		} else if ( (nodeC = getClosestAncestorIn(nodeB, nodeA, true)) ) {
			// Case 2: node C (container B or an ancestor) is a child node of A
			return offsetA <= getNodeIndex(nodeC) ? -1 : 1;
		} else if ( (nodeC = getClosestAncestorIn(nodeA, nodeB, true)) ) {
			// Case 3: node C (container A or an ancestor) is a child node of B
			return getNodeIndex(nodeC) < offsetB  ? -1 : 1;
		} else {
			root = getCommonAncestor(nodeA, nodeB);
			if (!root) {
				throw new Error("comparePoints error: nodes have no common ancestor");
			}

			// Case 4: containers are siblings or descendants of siblings
			childA = (nodeA === root) ? root : getClosestAncestorIn(nodeA, root, true);
			childB = (nodeB === root) ? root : getClosestAncestorIn(nodeB, root, true);

			if (childA === childB) {
				// This shouldn't be possible
				throw module.createError("comparePoints got to case 4 and childA and childB are the same!");
			} else {
				n = root.firstChild;
				while (n) {
					if (n === childA) {
						return -1;
					} else if (n === childB) {
						return 1;
					}
					n = n.nextSibling;
				}
			}
		}
	}

	/*----------------------------------------------------------------------------------------------------------------*/

	// Test for IE's crash (IE 6/7) or exception (IE >= 8) when a reference to garbage-collected text node is queried
	var crashyTextNodes = false;

	function isBrokenNode(node) {
        var n;
		try {
            n = node.parentNode;
			return false;
		} catch (e) {
			return true;
		}
	}

	(function() {
		var el = document.createElement("b");
		el.innerHTML = "1";
		var textNode = el.firstChild;
		el.innerHTML = "<br>";
		crashyTextNodes = isBrokenNode(textNode);

		api.features.crashyTextNodes = crashyTextNodes;
	})();

	/*----------------------------------------------------------------------------------------------------------------*/

	function inspectNode(node) {
		if (!node) {
			return "[No node]";
		}
		if (crashyTextNodes && isBrokenNode(node)) {
			return "[Broken node]";
		}
		if (isCharacterDataNode(node)) {
			return '"' + node.data + '"';
		}
		if (node.nodeType == 1) {
			var idAttr = node.id ? ' id="' + node.id + '"' : "";
            return "<" + node.nodeName + idAttr + ">[index:" + getNodeIndex(node) + ",length:" + node.childNodes.length + "][" + (node.innerHTML || "[innerHTML not supported]").slice(0, 25) + "]";
		}
			return node.nodeName;
		}

	function fragmentFromNodeChildren(node) {
		var fragment = getDocument(node).createDocumentFragment(), child;
		while ( (child = node.firstChild) ) {
			fragment.appendChild(child);
		}
		return fragment;
	}

	var getComputedStyleProperty;
	if (typeof window.getComputedStyle != UNDEF) {
		getComputedStyleProperty = function(el, propName) {
			return getWindow(el).getComputedStyle(el, null)[propName];
		};
	} else if (typeof document.documentElement.currentStyle != UNDEF) {
		getComputedStyleProperty = function(el, propName) {
			return el.currentStyle[propName];
		};
	} else {
		module.fail("No means of obtaining computed style properties found");
	}

	function NodeIterator(root) {
		this.root = root;
		this._next = root;
	}

	NodeIterator.prototype = {
		_current: null,

		hasNext: function() {
			return !!this._next;
		},

		next: function() {
			var n = this._current = this._next;
			var child, next;
			if (this._current) {
				child = n.firstChild;
				if (child) {
					this._next = child;
				} else {
					next = null;
					while ((n !== this.root) && !(next = n.nextSibling)) {
						n = n.parentNode;
					}
					this._next = next;
				}
			}
			return this._current;
		},

		detach: function() {
			this._current = this._next = this.root = null;
		}
	};

	function createIterator(root) {
		return new NodeIterator(root);
	}

	function DomPosition(node, offset) {
		this.node = node;
		this.offset = offset;
	}

	DomPosition.prototype = {
		equals: function(pos) {
			return !!pos && this.node === pos.node && this.offset == pos.offset;
		},

		inspect: function() {
			return "[DomPosition(" + inspectNode(this.node) + ":" + this.offset + ")]";
		},

		toString: function() {
			return this.inspect();
		}
	};

	function DOMException(codeName) {
		this.code = this[codeName];
		this.codeName = codeName;
		this.message = "DOMException: " + this.codeName;
	}

	DOMException.prototype = {
		INDEX_SIZE_ERR: 1,
		HIERARCHY_REQUEST_ERR: 3,
		WRONG_DOCUMENT_ERR: 4,
		NO_MODIFICATION_ALLOWED_ERR: 7,
		NOT_FOUND_ERR: 8,
		NOT_SUPPORTED_ERR: 9,
        INVALID_STATE_ERR: 11,
        INVALID_NODE_TYPE_ERR: 24
	};

	DOMException.prototype.toString = function() {
		return this.message;
	};

	api.dom = {
		arrayContains: arrayContains,
		isHtmlNamespace: isHtmlNamespace,
		parentElement: parentElement,
		getNodeIndex: getNodeIndex,
		getNodeLength: getNodeLength,
		getCommonAncestor: getCommonAncestor,
		isAncestorOf: isAncestorOf,
		isOrIsAncestorOf: isOrIsAncestorOf,
		getClosestAncestorIn: getClosestAncestorIn,
		isCharacterDataNode: isCharacterDataNode,
		isTextOrCommentNode: isTextOrCommentNode,
		insertAfter: insertAfter,
		splitDataNode: splitDataNode,
		getDocument: getDocument,
		getWindow: getWindow,
		getIframeWindow: getIframeWindow,
		getIframeDocument: getIframeDocument,
		getBody: util.getBody,
		isWindow: isWindow,
		getContentDocument: getContentDocument,
		getRootContainer: getRootContainer,
		comparePoints: comparePoints,
		isBrokenNode: isBrokenNode,
		inspectNode: inspectNode,
		getComputedStyleProperty: getComputedStyleProperty,
		fragmentFromNodeChildren: fragmentFromNodeChildren,
		createIterator: createIterator,
		DomPosition: DomPosition
	};

	api.DOMException = DOMException;
});
rangy.createCoreModule("DomRange", ["DomUtil"], function(api, module) {
	var dom = api.dom;
	var util = api.util;
	var DomPosition = dom.DomPosition;
	var DOMException = api.DOMException;
	
	var isCharacterDataNode = dom.isCharacterDataNode;
	var getNodeIndex = dom.getNodeIndex;
	var isOrIsAncestorOf = dom.isOrIsAncestorOf;
	var getDocument = dom.getDocument;
	var comparePoints = dom.comparePoints;
	var splitDataNode = dom.splitDataNode;
	var getClosestAncestorIn = dom.getClosestAncestorIn;
	var getNodeLength = dom.getNodeLength;
	var arrayContains = dom.arrayContains;
	var getRootContainer = dom.getRootContainer;
	var crashyTextNodes = api.features.crashyTextNodes;

	/*----------------------------------------------------------------------------------------------------------------*/

	// Utility functions

	function isNonTextPartiallySelected(node, range) {
		return (node.nodeType != 3) &&
			   (isOrIsAncestorOf(node, range.startContainer) || isOrIsAncestorOf(node, range.endContainer));
	}

	function getRangeDocument(range) {
		return range.document || getDocument(range.startContainer);
	}

	function getBoundaryBeforeNode(node) {
		return new DomPosition(node.parentNode, getNodeIndex(node));
	}

	function getBoundaryAfterNode(node) {
		return new DomPosition(node.parentNode, getNodeIndex(node) + 1);
	}

	function insertNodeAtPosition(node, n, o) {
		var firstNodeInserted = node.nodeType == 11 ? node.firstChild : node;
		if (isCharacterDataNode(n)) {
			if (o == n.length) {
				dom.insertAfter(node, n);
			} else {
				n.parentNode.insertBefore(node, o == 0 ? n : splitDataNode(n, o));
			}
		} else if (o >= n.childNodes.length) {
			n.appendChild(node);
		} else {
			n.insertBefore(node, n.childNodes[o]);
		}
		return firstNodeInserted;
	}

	function rangesIntersect(rangeA, rangeB, touchingIsIntersecting) {
		assertRangeValid(rangeA);
		assertRangeValid(rangeB);

		if (getRangeDocument(rangeB) != getRangeDocument(rangeA)) {
			throw new DOMException("WRONG_DOCUMENT_ERR");
		}

		var startComparison = comparePoints(rangeA.startContainer, rangeA.startOffset, rangeB.endContainer, rangeB.endOffset),
			endComparison = comparePoints(rangeA.endContainer, rangeA.endOffset, rangeB.startContainer, rangeB.startOffset);

		return touchingIsIntersecting ? startComparison <= 0 && endComparison >= 0 : startComparison < 0 && endComparison > 0;
	}

	function cloneSubtree(iterator) {
		var partiallySelected;
		for (var node, frag = getRangeDocument(iterator.range).createDocumentFragment(), subIterator; node = iterator.next(); ) {
			partiallySelected = iterator.isPartiallySelectedSubtree();
			node = node.cloneNode(!partiallySelected);
			if (partiallySelected) {
				subIterator = iterator.getSubtreeIterator();
				node.appendChild(cloneSubtree(subIterator));
                subIterator.detach();
			}

			if (node.nodeType == 10) { // DocumentType
				throw new DOMException("HIERARCHY_REQUEST_ERR");
			}
			frag.appendChild(node);
		}
		return frag;
	}

	function iterateSubtree(rangeIterator, func, iteratorState) {
		var it, n;
		iteratorState = iteratorState || { stop: false };
		for (var node, subRangeIterator; node = rangeIterator.next(); ) {
			if (rangeIterator.isPartiallySelectedSubtree()) {
				if (func(node) === false) {
					iteratorState.stop = true;
					return;
				} else {
					// The node is partially selected by the Range, so we can use a new RangeIterator on the portion of
					// the node selected by the Range.
					subRangeIterator = rangeIterator.getSubtreeIterator();
					iterateSubtree(subRangeIterator, func, iteratorState);
                    subRangeIterator.detach();
					if (iteratorState.stop) {
						return;
					}
				}
			} else {
				// The whole node is selected, so we can use efficient DOM iteration to iterate over the node and its
				// descendants
				it = dom.createIterator(node);
				while ( (n = it.next()) ) {
					if (func(n) === false) {
						iteratorState.stop = true;
						return;
					}
				}
			}
		}
	}

	function deleteSubtree(iterator) {
		var subIterator;
		while (iterator.next()) {
			if (iterator.isPartiallySelectedSubtree()) {
				subIterator = iterator.getSubtreeIterator();
				deleteSubtree(subIterator);
                subIterator.detach();
			} else {
				iterator.remove();
			}
		}
	}

	function extractSubtree(iterator) {
		for (var node, frag = getRangeDocument(iterator.range).createDocumentFragment(), subIterator; node = iterator.next(); ) {

			if (iterator.isPartiallySelectedSubtree()) {
				node = node.cloneNode(false);
				subIterator = iterator.getSubtreeIterator();
				node.appendChild(extractSubtree(subIterator));
                subIterator.detach();
			} else {
				iterator.remove();
			}
			if (node.nodeType == 10) { // DocumentType
				throw new DOMException("HIERARCHY_REQUEST_ERR");
			}
			frag.appendChild(node);
		}
		return frag;
	}

	function getNodesInRange(range, nodeTypes, filter) {
		var filterNodeTypes = !!(nodeTypes && nodeTypes.length), regex;
		var filterExists = !!filter;
		if (filterNodeTypes) {
			regex = new RegExp("^(" + nodeTypes.join("|") + ")$");
		}

		var nodes = [];
		iterateSubtree(new RangeIterator(range, false), function(node) {
			if (filterNodeTypes && !regex.test(node.nodeType)) {
				return;
			}
			if (filterExists && !filter(node)) {
				return;
			}
			// Don't include a boundary container if it is a character data node and the range does not contain any
			// of its character data. See issue 190.
			var sc = range.startContainer;
			if (node == sc && isCharacterDataNode(sc) && range.startOffset == sc.length) {
				return;
			}

			var ec = range.endContainer;
			if (node == ec && isCharacterDataNode(ec) && range.endOffset == 0) {
				return;
			}

				nodes.push(node);
		});
		return nodes;
	}

	function inspect(range) {
		var name = (typeof range.getName == "undefined") ? "Range" : range.getName();
		return "[" + name + "(" + dom.inspectNode(range.startContainer) + ":" + range.startOffset + ", " +
				dom.inspectNode(range.endContainer) + ":" + range.endOffset + ")]";
	}

	/*----------------------------------------------------------------------------------------------------------------*/

	// RangeIterator code partially borrows from IERange by Tim Ryan (http://github.com/timcameronryan/IERange)

	function RangeIterator(range, clonePartiallySelectedTextNodes) {
		this.range = range;
		this.clonePartiallySelectedTextNodes = clonePartiallySelectedTextNodes;


		if (!range.collapsed) {
			this.sc = range.startContainer;
			this.so = range.startOffset;
			this.ec = range.endContainer;
			this.eo = range.endOffset;
			var root = range.commonAncestorContainer;

			if (this.sc === this.ec && isCharacterDataNode(this.sc)) {
				this.isSingleCharacterDataNode = true;
				this._first = this._last = this._next = this.sc;
			} else {
				this._first = this._next = (this.sc === root && !isCharacterDataNode(this.sc)) ?
					this.sc.childNodes[this.so] : getClosestAncestorIn(this.sc, root, true);
				this._last = (this.ec === root && !isCharacterDataNode(this.ec)) ?
					this.ec.childNodes[this.eo - 1] : getClosestAncestorIn(this.ec, root, true);
			}
		}
	}

	RangeIterator.prototype = {
		_current: null,
		_next: null,
		_first: null,
		_last: null,
		isSingleCharacterDataNode: false,

		reset: function() {
			this._current = null;
			this._next = this._first;
		},

		hasNext: function() {
			return !!this._next;
		},

		next: function() {
			// Move to next node
			var current = this._current = this._next;
			if (current) {
				this._next = (current !== this._last) ? current.nextSibling : null;

				// Check for partially selected text nodes
				if (isCharacterDataNode(current) && this.clonePartiallySelectedTextNodes) {
					if (current === this.ec) {
						(current = current.cloneNode(true)).deleteData(this.eo, current.length - this.eo);
					}
					if (this._current === this.sc) {
						(current = current.cloneNode(true)).deleteData(0, this.so);
					}
				}
			}

			return current;
		},

		remove: function() {
			var current = this._current, start, end;

			if (isCharacterDataNode(current) && (current === this.sc || current === this.ec)) {
				start = (current === this.sc) ? this.so : 0;
				end = (current === this.ec) ? this.eo : current.length;
				if (start != end) {
					current.deleteData(start, end - start);
				}
			} else {
				if (current.parentNode) {
					current.parentNode.removeChild(current);
				} else {
				}
			}
		},

		// Checks if the current node is partially selected
		isPartiallySelectedSubtree: function() {
			var current = this._current;
			return isNonTextPartiallySelected(current, this.range);
		},

		getSubtreeIterator: function() {
			var subRange;
			if (this.isSingleCharacterDataNode) {
				subRange = this.range.cloneRange();
				subRange.collapse(false);
			} else {
				subRange = new Range(getRangeDocument(this.range));
				var current = this._current;
				var startContainer = current, startOffset = 0, endContainer = current, endOffset = getNodeLength(current);

				if (isOrIsAncestorOf(current, this.sc)) {
					startContainer = this.sc;
					startOffset = this.so;
				}
				if (isOrIsAncestorOf(current, this.ec)) {
					endContainer = this.ec;
					endOffset = this.eo;
				}

				updateBoundaries(subRange, startContainer, startOffset, endContainer, endOffset);
			}
			return new RangeIterator(subRange, this.clonePartiallySelectedTextNodes);
		},

        detach: function() {
			this.range = this._current = this._next = this._first = this._last = this.sc = this.so = this.ec = this.eo = null;
		}
	};

	/*----------------------------------------------------------------------------------------------------------------*/

	var beforeAfterNodeTypes = [1, 3, 4, 5, 7, 8, 10];
	var rootContainerNodeTypes = [2, 9, 11];
	var readonlyNodeTypes = [5, 6, 10, 12];
	var insertableNodeTypes = [1, 3, 4, 5, 7, 8, 10, 11];
	var surroundNodeTypes = [1, 3, 4, 5, 7, 8];

	function createAncestorFinder(nodeTypes) {
		return function(node, selfIsAncestor) {
			var t, n = selfIsAncestor ? node : node.parentNode;
			while (n) {
				t = n.nodeType;
				if (arrayContains(nodeTypes, t)) {
					return n;
				}
				n = n.parentNode;
			}
			return null;
		};
	}

	var getDocumentOrFragmentContainer = createAncestorFinder( [9, 11] );
	var getReadonlyAncestor = createAncestorFinder(readonlyNodeTypes);
	var getDocTypeNotationEntityAncestor = createAncestorFinder( [6, 10, 12] );

	function assertNoDocTypeNotationEntityAncestor(node, allowSelf) {
		if (getDocTypeNotationEntityAncestor(node, allowSelf)) {
            throw new DOMException("INVALID_NODE_TYPE_ERR");
		}
	}

	function assertValidNodeType(node, invalidTypes) {
		if (!arrayContains(invalidTypes, node.nodeType)) {
            throw new DOMException("INVALID_NODE_TYPE_ERR");
		}
	}

	function assertValidOffset(node, offset) {
		if (offset < 0 || offset > (isCharacterDataNode(node) ? node.length : node.childNodes.length)) {
			throw new DOMException("INDEX_SIZE_ERR");
		}
	}

	function assertSameDocumentOrFragment(node1, node2) {
		if (getDocumentOrFragmentContainer(node1, true) !== getDocumentOrFragmentContainer(node2, true)) {
			throw new DOMException("WRONG_DOCUMENT_ERR");
		}
	}

	function assertNodeNotReadOnly(node) {
		if (getReadonlyAncestor(node, true)) {
			throw new DOMException("NO_MODIFICATION_ALLOWED_ERR");
		}
	}

	function assertNode(node, codeName) {
		if (!node) {
			throw new DOMException(codeName);
		}
	}

	function isOrphan(node) {
		return (crashyTextNodes && dom.isBrokenNode(node)) ||
			!arrayContains(rootContainerNodeTypes, node.nodeType) && !getDocumentOrFragmentContainer(node, true);
	}

	function isValidOffset(node, offset) {
		return offset <= (isCharacterDataNode(node) ? node.length : node.childNodes.length);
	}

	function isRangeValid(range) {
        return (!!range.startContainer && !!range.endContainer &&
                !isOrphan(range.startContainer) &&
                !isOrphan(range.endContainer) &&
                isValidOffset(range.startContainer, range.startOffset) &&
                isValidOffset(range.endContainer, range.endOffset));
	}

	function assertRangeValid(range) {
		if (!isRangeValid(range)) {
			throw new Error("Range error: Range is no longer valid after DOM mutation (" + range.inspect() + ")");
		}
	}

	/*----------------------------------------------------------------------------------------------------------------*/

	// Test the browser's innerHTML support to decide how to implement createContextualFragment
	var styleEl = document.createElement("style");
	var htmlParsingConforms = false;
	try {
		styleEl.innerHTML = "<b>x</b>";
		htmlParsingConforms = (styleEl.firstChild.nodeType == 3); // Opera incorrectly creates an element node
	} catch (e) {
		// IE 6 and 7 throw
	}

	api.features.htmlParsingConforms = htmlParsingConforms;

	var createContextualFragment = htmlParsingConforms ?

		// Implementation as per HTML parsing spec, trusting in the browser's implementation of innerHTML. See
		// discussion and base code for this implementation at issue 67.
		// Spec: http://html5.org/specs/dom-parsing.html#extensions-to-the-range-interface
		// Thanks to Aleks Williams.
		function(fragmentStr) {
			// "Let node the context object's start's node."
			var node = this.startContainer;
			var doc = getDocument(node);

			// "If the context object's start's node is null, raise an INVALID_STATE_ERR
			// exception and abort these steps."
			if (!node) {
				throw new DOMException("INVALID_STATE_ERR");
			}

			// "Let element be as follows, depending on node's interface:"
			// Document, Document Fragment: null
			var el = null;

			// "Element: node"
			if (node.nodeType == 1) {
				el = node;

			// "Text, Comment: node's parentElement"
			} else if (isCharacterDataNode(node)) {
				el = dom.parentElement(node);
			}

			// "If either element is null or element's ownerDocument is an HTML document
			// and element's local name is "html" and element's namespace is the HTML
			// namespace"
			if (el === null || (
                el.nodeName == "HTML" &&
                dom.isHtmlNamespace(getDocument(el).documentElement) &&
                dom.isHtmlNamespace(el)
			)) {

			// "let element be a new Element with "body" as its local name and the HTML
			// namespace as its namespace.""
				el = doc.createElement("body");
			} else {
				el = el.cloneNode(false);
			}

			// "If the node's document is an HTML document: Invoke the HTML fragment parsing algorithm."
			// "If the node's document is an XML document: Invoke the XML fragment parsing algorithm."
			// "In either case, the algorithm must be invoked with fragment as the input
			// and element as the context element."
			el.innerHTML = fragmentStr;

			// "If this raises an exception, then abort these steps. Otherwise, let new
			// children be the nodes returned."

			// "Let fragment be a new DocumentFragment."
			// "Append all new children to fragment."
			// "Return fragment."
			return dom.fragmentFromNodeChildren(el);
		} :

		// In this case, innerHTML cannot be trusted, so fall back to a simpler, non-conformant implementation that
		// previous versions of Rangy used (with the exception of using a body element rather than a div)
		function(fragmentStr) {
			var doc = getRangeDocument(this);
			var el = doc.createElement("body");
			el.innerHTML = fragmentStr;

			return dom.fragmentFromNodeChildren(el);
		};

	function splitRangeBoundaries(range, positionsToPreserve) {
		assertRangeValid(range);

		var sc = range.startContainer, so = range.startOffset, ec = range.endContainer, eo = range.endOffset;
		var startEndSame = (sc === ec);

		if (isCharacterDataNode(ec) && eo > 0 && eo < ec.length) {
			splitDataNode(ec, eo, positionsToPreserve);
		}

		if (isCharacterDataNode(sc) && so > 0 && so < sc.length) {
			sc = splitDataNode(sc, so, positionsToPreserve);
			if (startEndSame) {
				eo -= so;
				ec = sc;
			} else if (ec == sc.parentNode && eo >= getNodeIndex(sc)) {
				eo++;
			}
			so = 0;
		}
		range.setStartAndEnd(sc, so, ec, eo);
	}

	/*----------------------------------------------------------------------------------------------------------------*/

	var rangeProperties = ["startContainer", "startOffset", "endContainer", "endOffset", "collapsed",
		"commonAncestorContainer"];

	var s2s = 0, s2e = 1, e2e = 2, e2s = 3;
	var n_b = 0, n_a = 1, n_b_a = 2, n_i = 3;

	util.extend(api.rangePrototype, {
		compareBoundaryPoints: function(how, range) {
			assertRangeValid(this);
			assertSameDocumentOrFragment(this.startContainer, range.startContainer);

			var nodeA, offsetA, nodeB, offsetB;
			var prefixA = (how == e2s || how == s2s) ? "start" : "end";
			var prefixB = (how == s2e || how == s2s) ? "start" : "end";
			nodeA = this[prefixA + "Container"];
			offsetA = this[prefixA + "Offset"];
			nodeB = range[prefixB + "Container"];
			offsetB = range[prefixB + "Offset"];
			return comparePoints(nodeA, offsetA, nodeB, offsetB);
		},

		insertNode: function(node) {
			assertRangeValid(this);
			assertValidNodeType(node, insertableNodeTypes);
			assertNodeNotReadOnly(this.startContainer);

			if (isOrIsAncestorOf(node, this.startContainer)) {
				throw new DOMException("HIERARCHY_REQUEST_ERR");
			}

			// No check for whether the container of the start of the Range is of a type that does not allow
			// children of the type of node: the browser's DOM implementation should do this for us when we attempt
			// to add the node

			var firstNodeInserted = insertNodeAtPosition(node, this.startContainer, this.startOffset);
			this.setStartBefore(firstNodeInserted);
		},

		cloneContents: function() {
			assertRangeValid(this);

			var clone, frag;
			if (this.collapsed) {
				return getRangeDocument(this).createDocumentFragment();
			} else {
				if (this.startContainer === this.endContainer && isCharacterDataNode(this.startContainer)) {
					clone = this.startContainer.cloneNode(true);
					clone.data = clone.data.slice(this.startOffset, this.endOffset);
					frag = getRangeDocument(this).createDocumentFragment();
					frag.appendChild(clone);
					return frag;
				} else {
					var iterator = new RangeIterator(this, true);
					clone = cloneSubtree(iterator);
					iterator.detach();
				}
				return clone;
			}
		},

		canSurroundContents: function() {
			assertRangeValid(this);
			assertNodeNotReadOnly(this.startContainer);
			assertNodeNotReadOnly(this.endContainer);

			// Check if the contents can be surrounded. Specifically, this means whether the range partially selects
			// no non-text nodes.
			var iterator = new RangeIterator(this, true);
			var boundariesInvalid = (iterator._first && (isNonTextPartiallySelected(iterator._first, this)) ||
					(iterator._last && isNonTextPartiallySelected(iterator._last, this)));
			iterator.detach();
			return !boundariesInvalid;
		},

		surroundContents: function(node) {
			assertValidNodeType(node, surroundNodeTypes);

			if (!this.canSurroundContents()) {
                throw new DOMException("INVALID_STATE_ERR");
			}

			// Extract the contents
			var content = this.extractContents();

			// Clear the children of the node
			if (node.hasChildNodes()) {
				while (node.lastChild) {
					node.removeChild(node.lastChild);
				}
			}

			// Insert the new node and add the extracted contents
			insertNodeAtPosition(node, this.startContainer, this.startOffset);
			node.appendChild(content);

			this.selectNode(node);
		},

		cloneRange: function() {
			assertRangeValid(this);
			var range = new Range(getRangeDocument(this));
			var i = rangeProperties.length, prop;
			while (i--) {
				prop = rangeProperties[i];
				range[prop] = this[prop];
			}
			return range;
		},

		toString: function() {
			assertRangeValid(this);
			var sc = this.startContainer;
			if (sc === this.endContainer && isCharacterDataNode(sc)) {
				return (sc.nodeType == 3 || sc.nodeType == 4) ? sc.data.slice(this.startOffset, this.endOffset) : "";
			} else {
				var textParts = [], iterator = new RangeIterator(this, true);
				iterateSubtree(iterator, function(node) {
					// Accept only text or CDATA nodes, not comments
					if (node.nodeType == 3 || node.nodeType == 4) {
						textParts.push(node.data);
					}
				});
				iterator.detach();
				return textParts.join("");
			}
		},

		// The methods below are all non-standard. The following batch were introduced by Mozilla but have since
		// been removed from Mozilla.

		compareNode: function(node) {
			assertRangeValid(this);

			var parent = node.parentNode;
			var nodeIndex = getNodeIndex(node);

			if (!parent) {
				throw new DOMException("NOT_FOUND_ERR");
			}

			var startComparison = this.comparePoint(parent, nodeIndex),
				endComparison = this.comparePoint(parent, nodeIndex + 1);

			if (startComparison < 0) { // Node starts before
				return (endComparison > 0) ? n_b_a : n_b;
			} else {
				return (endComparison > 0) ? n_a : n_i;
			}
		},

		comparePoint: function(node, offset) {
			assertRangeValid(this);
			assertNode(node, "HIERARCHY_REQUEST_ERR");
			assertSameDocumentOrFragment(node, this.startContainer);

			if (comparePoints(node, offset, this.startContainer, this.startOffset) < 0) {
				return -1;
			} else if (comparePoints(node, offset, this.endContainer, this.endOffset) > 0) {
				return 1;
			}
			return 0;
		},

		createContextualFragment: createContextualFragment,

		toHtml: function() {
			assertRangeValid(this);
			var container = this.commonAncestorContainer.parentNode.cloneNode(false);
			container.appendChild(this.cloneContents());
			return container.innerHTML;
		},

		// touchingIsIntersecting determines whether this method considers a node that borders a range intersects
		// with it (as in WebKit) or not (as in Gecko pre-1.9, and the default)
		intersectsNode: function(node, touchingIsIntersecting) {
			assertRangeValid(this);
			assertNode(node, "NOT_FOUND_ERR");
			if (getDocument(node) !== getRangeDocument(this)) {
				return false;
			}

			var parent = node.parentNode, offset = getNodeIndex(node);
			assertNode(parent, "NOT_FOUND_ERR");

			var startComparison = comparePoints(parent, offset, this.endContainer, this.endOffset),
				endComparison = comparePoints(parent, offset + 1, this.startContainer, this.startOffset);

			return touchingIsIntersecting ? startComparison <= 0 && endComparison >= 0 : startComparison < 0 && endComparison > 0;
		},

		isPointInRange: function(node, offset) {
			assertRangeValid(this);
			assertNode(node, "HIERARCHY_REQUEST_ERR");
			assertSameDocumentOrFragment(node, this.startContainer);

			return (comparePoints(node, offset, this.startContainer, this.startOffset) >= 0) &&
				   (comparePoints(node, offset, this.endContainer, this.endOffset) <= 0);
		},

		// The methods below are non-standard and invented by me.

		// Sharing a boundary start-to-end or end-to-start does not count as intersection.
		intersectsRange: function(range) {
			return rangesIntersect(this, range, false);
		},

		// Sharing a boundary start-to-end or end-to-start does count as intersection.
		intersectsOrTouchesRange: function(range) {
			return rangesIntersect(this, range, true);
		},

		intersection: function(range) {
			if (this.intersectsRange(range)) {
				var startComparison = comparePoints(this.startContainer, this.startOffset, range.startContainer, range.startOffset),
					endComparison = comparePoints(this.endContainer, this.endOffset, range.endContainer, range.endOffset);

				var intersectionRange = this.cloneRange();
				if (startComparison == -1) {
					intersectionRange.setStart(range.startContainer, range.startOffset);
				}
				if (endComparison == 1) {
					intersectionRange.setEnd(range.endContainer, range.endOffset);
				}
				return intersectionRange;
			}
			return null;
		},

		union: function(range) {
			if (this.intersectsOrTouchesRange(range)) {
				var unionRange = this.cloneRange();
				if (comparePoints(range.startContainer, range.startOffset, this.startContainer, this.startOffset) == -1) {
					unionRange.setStart(range.startContainer, range.startOffset);
				}
				if (comparePoints(range.endContainer, range.endOffset, this.endContainer, this.endOffset) == 1) {
					unionRange.setEnd(range.endContainer, range.endOffset);
				}
				return unionRange;
			} else {
                throw new DOMException("Ranges do not intersect");
			}
		},

		containsNode: function(node, allowPartial) {
			if (allowPartial) {
				return this.intersectsNode(node, false);
			} else {
				return this.compareNode(node) == n_i;
			}
		},

		containsNodeContents: function(node) {
			return this.comparePoint(node, 0) >= 0 && this.comparePoint(node, getNodeLength(node)) <= 0;
		},

		containsRange: function(range) {
			var intersection = this.intersection(range);
			return intersection !== null && range.equals(intersection);
		},

		containsNodeText: function(node) {
			var nodeRange = this.cloneRange();
			nodeRange.selectNode(node);
			var textNodes = nodeRange.getNodes([3]);
			if (textNodes.length > 0) {
				nodeRange.setStart(textNodes[0], 0);
				var lastTextNode = textNodes.pop();
				nodeRange.setEnd(lastTextNode, lastTextNode.length);
                return this.containsRange(nodeRange);
			} else {
				return this.containsNodeContents(node);
			}
		},

		getNodes: function(nodeTypes, filter) {
			assertRangeValid(this);
			return getNodesInRange(this, nodeTypes, filter);
		},

		getDocument: function() {
			return getRangeDocument(this);
		},

		collapseBefore: function(node) {
			this.setEndBefore(node);
			this.collapse(false);
		},

		collapseAfter: function(node) {
			this.setStartAfter(node);
			this.collapse(true);
		},

		getBookmark: function(containerNode) {
			var doc = getRangeDocument(this);
			var preSelectionRange = api.createRange(doc);
			containerNode = containerNode || dom.getBody(doc);
			preSelectionRange.selectNodeContents(containerNode);
			var range = this.intersection(preSelectionRange);
			var start = 0, end = 0;
			if (range) {
				preSelectionRange.setEnd(range.startContainer, range.startOffset);
				start = preSelectionRange.toString().length;
				end = start + range.toString().length;
			}

			return {
				start: start,
				end: end,
				containerNode: containerNode
			};
		},
		
		moveToBookmark: function(bookmark) {
			var containerNode = bookmark.containerNode;
			var charIndex = 0;
			this.setStart(containerNode, 0);
			this.collapse(true);
			var nodeStack = [containerNode], node, foundStart = false, stop = false;
			var nextCharIndex, i, childNodes;

			while (!stop && (node = nodeStack.pop())) {
				if (node.nodeType == 3) {
					nextCharIndex = charIndex + node.length;
					if (!foundStart && bookmark.start >= charIndex && bookmark.start <= nextCharIndex) {
						this.setStart(node, bookmark.start - charIndex);
						foundStart = true;
					}
					if (foundStart && bookmark.end >= charIndex && bookmark.end <= nextCharIndex) {
						this.setEnd(node, bookmark.end - charIndex);
						stop = true;
					}
					charIndex = nextCharIndex;
				} else {
					childNodes = node.childNodes;
					i = childNodes.length;
					while (i--) {
						nodeStack.push(childNodes[i]);
					}
				}
			}
		},

		getName: function() {
			return "DomRange";
		},

		equals: function(range) {
			return Range.rangesEqual(this, range);
		},

		isValid: function() {
			return isRangeValid(this);
		},

		inspect: function() {
			return inspect(this);
        },
        
        detach: function() {
            // In DOM4, detach() is now a no-op.
		}
	});

	function copyComparisonConstantsToObject(obj) {
		obj.START_TO_START = s2s;
		obj.START_TO_END = s2e;
		obj.END_TO_END = e2e;
		obj.END_TO_START = e2s;

		obj.NODE_BEFORE = n_b;
		obj.NODE_AFTER = n_a;
		obj.NODE_BEFORE_AND_AFTER = n_b_a;
		obj.NODE_INSIDE = n_i;
	}

	function copyComparisonConstants(constructor) {
		copyComparisonConstantsToObject(constructor);
		copyComparisonConstantsToObject(constructor.prototype);
	}

	function createRangeContentRemover(remover, boundaryUpdater) {
		return function() {
			assertRangeValid(this);

			var sc = this.startContainer, so = this.startOffset, root = this.commonAncestorContainer;

			var iterator = new RangeIterator(this, true);

			// Work out where to position the range after content removal
			var node, boundary;
			if (sc !== root) {
				node = getClosestAncestorIn(sc, root, true);
				boundary = getBoundaryAfterNode(node);
				sc = boundary.node;
				so = boundary.offset;
			}

			// Check none of the range is read-only
			iterateSubtree(iterator, assertNodeNotReadOnly);

			iterator.reset();

			// Remove the content
			var returnValue = remover(iterator);
			iterator.detach();

			// Move to the new position
			boundaryUpdater(this, sc, so, sc, so);

			return returnValue;
		};
	}

    function createPrototypeRange(constructor, boundaryUpdater) {
		function createBeforeAfterNodeSetter(isBefore, isStart) {
			return function(node) {
				assertValidNodeType(node, beforeAfterNodeTypes);
				assertValidNodeType(getRootContainer(node), rootContainerNodeTypes);

				var boundary = (isBefore ? getBoundaryBeforeNode : getBoundaryAfterNode)(node);
				(isStart ? setRangeStart : setRangeEnd)(this, boundary.node, boundary.offset);
			};
		}

		function setRangeStart(range, node, offset) {
			var ec = range.endContainer, eo = range.endOffset;
			if (node !== range.startContainer || offset !== range.startOffset) {
				// Check the root containers of the range and the new boundary, and also check whether the new boundary
				// is after the current end. In either case, collapse the range to the new position
				if (getRootContainer(node) != getRootContainer(ec) || comparePoints(node, offset, ec, eo) == 1) {
					ec = node;
					eo = offset;
				}
				boundaryUpdater(range, node, offset, ec, eo);
			}
		}

		function setRangeEnd(range, node, offset) {
			var sc = range.startContainer, so = range.startOffset;
			if (node !== range.endContainer || offset !== range.endOffset) {
				// Check the root containers of the range and the new boundary, and also check whether the new boundary
				// is after the current end. In either case, collapse the range to the new position
				if (getRootContainer(node) != getRootContainer(sc) || comparePoints(node, offset, sc, so) == -1) {
					sc = node;
					so = offset;
				}
				boundaryUpdater(range, sc, so, node, offset);
			}
		}

		// Set up inheritance
		var F = function() {};
		F.prototype = api.rangePrototype;
		constructor.prototype = new F();

		util.extend(constructor.prototype, {
			setStart: function(node, offset) {
				assertNoDocTypeNotationEntityAncestor(node, true);
				assertValidOffset(node, offset);

				setRangeStart(this, node, offset);
			},

			setEnd: function(node, offset) {
				assertNoDocTypeNotationEntityAncestor(node, true);
				assertValidOffset(node, offset);

				setRangeEnd(this, node, offset);
			},

			/**
			 * Convenience method to set a range's start and end boundaries. Overloaded as follows:
			 * - Two parameters (node, offset) creates a collapsed range at that position
			 * - Three parameters (node, startOffset, endOffset) creates a range contained with node starting at
			 *   startOffset and ending at endOffset
			 * - Four parameters (startNode, startOffset, endNode, endOffset) creates a range starting at startOffset in
			 *   startNode and ending at endOffset in endNode
			 */
			setStartAndEnd: function() {
				var args = arguments;
				var sc = args[0], so = args[1], ec = sc, eo = so;

				switch (args.length) {
					case 3:
						eo = args[2];
						break;
					case 4:
						ec = args[2];
						eo = args[3];
						break;
				}

				boundaryUpdater(this, sc, so, ec, eo);
			},
			
			setBoundary: function(node, offset, isStart) {
				this["set" + (isStart ? "Start" : "End")](node, offset);
			},

			setStartBefore: createBeforeAfterNodeSetter(true, true),
			setStartAfter: createBeforeAfterNodeSetter(false, true),
			setEndBefore: createBeforeAfterNodeSetter(true, false),
			setEndAfter: createBeforeAfterNodeSetter(false, false),

			collapse: function(isStart) {
				assertRangeValid(this);
				if (isStart) {
					boundaryUpdater(this, this.startContainer, this.startOffset, this.startContainer, this.startOffset);
				} else {
					boundaryUpdater(this, this.endContainer, this.endOffset, this.endContainer, this.endOffset);
				}
			},

			selectNodeContents: function(node) {
				assertNoDocTypeNotationEntityAncestor(node, true);

				boundaryUpdater(this, node, 0, node, getNodeLength(node));
			},

			selectNode: function(node) {
				assertNoDocTypeNotationEntityAncestor(node, false);
				assertValidNodeType(node, beforeAfterNodeTypes);

				var start = getBoundaryBeforeNode(node), end = getBoundaryAfterNode(node);
				boundaryUpdater(this, start.node, start.offset, end.node, end.offset);
			},

			extractContents: createRangeContentRemover(extractSubtree, boundaryUpdater),

			deleteContents: createRangeContentRemover(deleteSubtree, boundaryUpdater),

			canSurroundContents: function() {
				assertRangeValid(this);
				assertNodeNotReadOnly(this.startContainer);
				assertNodeNotReadOnly(this.endContainer);

				// Check if the contents can be surrounded. Specifically, this means whether the range partially selects
				// no non-text nodes.
				var iterator = new RangeIterator(this, true);
                var boundariesInvalid = (iterator._first && isNonTextPartiallySelected(iterator._first, this) ||
						(iterator._last && isNonTextPartiallySelected(iterator._last, this)));
				iterator.detach();
				return !boundariesInvalid;
			},

			splitBoundaries: function() {
				splitRangeBoundaries(this);
			},

			splitBoundariesPreservingPositions: function(positionsToPreserve) {
				splitRangeBoundaries(this, positionsToPreserve);
			},

			normalizeBoundaries: function() {
				assertRangeValid(this);

				var sc = this.startContainer, so = this.startOffset, ec = this.endContainer, eo = this.endOffset;

				var mergeForward = function(node) {
					var sibling = node.nextSibling;
					if (sibling && sibling.nodeType == node.nodeType) {
						ec = node;
						eo = node.length;
						node.appendData(sibling.data);
						sibling.parentNode.removeChild(sibling);
					}
				};

				var mergeBackward = function(node) {
					var sibling = node.previousSibling;
					if (sibling && sibling.nodeType == node.nodeType) {
						sc = node;
						var nodeLength = node.length;
						so = sibling.length;
						node.insertData(0, sibling.data);
						sibling.parentNode.removeChild(sibling);
						if (sc == ec) {
							eo += so;
							ec = sc;
						} else if (ec == node.parentNode) {
							var nodeIndex = getNodeIndex(node);
							if (eo == nodeIndex) {
								ec = node;
								eo = nodeLength;
							} else if (eo > nodeIndex) {
								eo--;
							}
						}
					}
				};

				var normalizeStart = true;

				if (isCharacterDataNode(ec)) {
					if (ec.length == eo) {
						mergeForward(ec);
					}
				} else {
					if (eo > 0) {
						var endNode = ec.childNodes[eo - 1];
						if (endNode && isCharacterDataNode(endNode)) {
							mergeForward(endNode);
						}
					}
					normalizeStart = !this.collapsed;
				}

				if (normalizeStart) {
					if (isCharacterDataNode(sc)) {
						if (so == 0) {
							mergeBackward(sc);
						}
					} else {
						if (so < sc.childNodes.length) {
							var startNode = sc.childNodes[so];
							if (startNode && isCharacterDataNode(startNode)) {
								mergeBackward(startNode);
							}
						}
					}
				} else {
					sc = ec;
					so = eo;
				}

				boundaryUpdater(this, sc, so, ec, eo);
			},

			collapseToPoint: function(node, offset) {
				assertNoDocTypeNotationEntityAncestor(node, true);
				assertValidOffset(node, offset);
				this.setStartAndEnd(node, offset);
			}
		});

		copyComparisonConstants(constructor);
	}

	/*----------------------------------------------------------------------------------------------------------------*/

	// Updates commonAncestorContainer and collapsed after boundary change
	function updateCollapsedAndCommonAncestor(range) {
		range.collapsed = (range.startContainer === range.endContainer && range.startOffset === range.endOffset);
		range.commonAncestorContainer = range.collapsed ?
			range.startContainer : dom.getCommonAncestor(range.startContainer, range.endContainer);
	}

	function updateBoundaries(range, startContainer, startOffset, endContainer, endOffset) {
		range.startContainer = startContainer;
		range.startOffset = startOffset;
		range.endContainer = endContainer;
		range.endOffset = endOffset;
		range.document = dom.getDocument(startContainer);

		updateCollapsedAndCommonAncestor(range);
	}

	function Range(doc) {
		this.startContainer = doc;
		this.startOffset = 0;
		this.endContainer = doc;
		this.endOffset = 0;
		this.document = doc;
		updateCollapsedAndCommonAncestor(this);
	}

    createPrototypeRange(Range, updateBoundaries);

	util.extend(Range, {
		rangeProperties: rangeProperties,
		RangeIterator: RangeIterator,
		copyComparisonConstants: copyComparisonConstants,
		createPrototypeRange: createPrototypeRange,
		inspect: inspect,
		getRangeDocument: getRangeDocument,
		rangesEqual: function(r1, r2) {
		return r1.startContainer === r2.startContainer &&
			   r1.startOffset === r2.startOffset &&
			   r1.endContainer === r2.endContainer &&
			   r1.endOffset === r2.endOffset;
		}
	});

	api.DomRange = Range;
});
rangy.createCoreModule("WrappedRange", ["DomRange"], function(api, module) {
	var WrappedRange, WrappedTextRange;
	var dom = api.dom;
	var util = api.util;
	var DomPosition = dom.DomPosition;
	var DomRange = api.DomRange;
	var getBody = dom.getBody;
	var getContentDocument = dom.getContentDocument;
	var isCharacterDataNode = dom.isCharacterDataNode;


	/*----------------------------------------------------------------------------------------------------------------*/

	if (api.features.implementsDomRange) {
		// This is a wrapper around the browser's native DOM Range. It has two aims:
		// - Provide workarounds for specific browser bugs
		// - provide convenient extensions, which are inherited from Rangy's DomRange

		(function() {
			var rangeProto;
			var rangeProperties = DomRange.rangeProperties;

			function updateRangeProperties(range) {
				var i = rangeProperties.length, prop;
				while (i--) {
					prop = rangeProperties[i];
					range[prop] = range.nativeRange[prop];
				}
				// Fix for broken collapsed property in IE 9.
				range.collapsed = (range.startContainer === range.endContainer && range.startOffset === range.endOffset);
			}

			function updateNativeRange(range, startContainer, startOffset, endContainer, endOffset) {
				var startMoved = (range.startContainer !== startContainer || range.startOffset != startOffset);
				var endMoved = (range.endContainer !== endContainer || range.endOffset != endOffset);
				var nativeRangeDifferent = !range.equals(range.nativeRange);

				// Always set both boundaries for the benefit of IE9 (see issue 35)
				if (startMoved || endMoved || nativeRangeDifferent) {
					range.setEnd(endContainer, endOffset);
					range.setStart(startContainer, startOffset);
				}
			}

			var createBeforeAfterNodeSetter;

			WrappedRange = function(range) {
				if (!range) {
					throw module.createError("WrappedRange: Range must be specified");
		}
				this.nativeRange = range;
				updateRangeProperties(this);
			};

            DomRange.createPrototypeRange(WrappedRange, updateNativeRange);

			rangeProto = WrappedRange.prototype;

			rangeProto.selectNode = function(node) {
				this.nativeRange.selectNode(node);
				updateRangeProperties(this);
			};

			rangeProto.cloneContents = function() {
				return this.nativeRange.cloneContents();
			};

			// Due to a long-standing Firefox bug that I have not been able to find a reliable way to detect,
			// insertNode() is never delegated to the native range.

			rangeProto.surroundContents = function(node) {
				this.nativeRange.surroundContents(node);
				updateRangeProperties(this);
			};

			rangeProto.collapse = function(isStart) {
				this.nativeRange.collapse(isStart);
				updateRangeProperties(this);
			};

			rangeProto.cloneRange = function() {
				return new WrappedRange(this.nativeRange.cloneRange());
			};

			rangeProto.refresh = function() {
				updateRangeProperties(this);
			};

			rangeProto.toString = function() {
				return this.nativeRange.toString();
			};

			// Create test range and node for feature detection

			var testTextNode = document.createTextNode("test");
			getBody(document).appendChild(testTextNode);
			var range = document.createRange();

			/*--------------------------------------------------------------------------------------------------------*/

			// Test for Firefox 2 bug that prevents moving the start of a Range to a point after its current end and
			// correct for it

			range.setStart(testTextNode, 0);
			range.setEnd(testTextNode, 0);

			try {
				range.setStart(testTextNode, 1);

				rangeProto.setStart = function(node, offset) {
					this.nativeRange.setStart(node, offset);
					updateRangeProperties(this);
				};

				rangeProto.setEnd = function(node, offset) {
					this.nativeRange.setEnd(node, offset);
					updateRangeProperties(this);
				};

				createBeforeAfterNodeSetter = function(name) {
					return function(node) {
						this.nativeRange[name](node);
						updateRangeProperties(this);
					};
				};

			} catch(ex) {

				rangeProto.setStart = function(node, offset) {
					try {
						this.nativeRange.setStart(node, offset);
                    } catch (ex) {
						this.nativeRange.setEnd(node, offset);
						this.nativeRange.setStart(node, offset);
					}
					updateRangeProperties(this);
				};

				rangeProto.setEnd = function(node, offset) {
					try {
						this.nativeRange.setEnd(node, offset);
                    } catch (ex) {
						this.nativeRange.setStart(node, offset);
						this.nativeRange.setEnd(node, offset);
					}
					updateRangeProperties(this);
				};

				createBeforeAfterNodeSetter = function(name, oppositeName) {
					return function(node) {
						try {
							this.nativeRange[name](node);
						} catch (ex) {
							this.nativeRange[oppositeName](node);
							this.nativeRange[name](node);
						}
						updateRangeProperties(this);
					};
				};
			}

			rangeProto.setStartBefore = createBeforeAfterNodeSetter("setStartBefore", "setEndBefore");
			rangeProto.setStartAfter = createBeforeAfterNodeSetter("setStartAfter", "setEndAfter");
			rangeProto.setEndBefore = createBeforeAfterNodeSetter("setEndBefore", "setStartBefore");
			rangeProto.setEndAfter = createBeforeAfterNodeSetter("setEndAfter", "setStartAfter");

			/*--------------------------------------------------------------------------------------------------------*/

			// Always use DOM4-compliant selectNodeContents implementation: it's simpler and less code than testing
			// whether the native implementation can be trusted
			rangeProto.selectNodeContents = function(node) {
				this.setStartAndEnd(node, 0, dom.getNodeLength(node));
			};

			/*--------------------------------------------------------------------------------------------------------*/

			// Test for and correct WebKit bug that has the behaviour of compareBoundaryPoints round the wrong way for
			// constants START_TO_END and END_TO_START: https://bugs.webkit.org/show_bug.cgi?id=20738

			range.selectNodeContents(testTextNode);
			range.setEnd(testTextNode, 3);

			var range2 = document.createRange();
			range2.selectNodeContents(testTextNode);
			range2.setEnd(testTextNode, 4);
			range2.setStart(testTextNode, 2);

			if (range.compareBoundaryPoints(range.START_TO_END, range2) == -1 &&
					range.compareBoundaryPoints(range.END_TO_START, range2) == 1) {
				// This is the wrong way round, so correct for it

				rangeProto.compareBoundaryPoints = function(type, range) {
					range = range.nativeRange || range;
					if (type == range.START_TO_END) {
						type = range.END_TO_START;
					} else if (type == range.END_TO_START) {
						type = range.START_TO_END;
				}
					return this.nativeRange.compareBoundaryPoints(type, range);
				};
			} else {
				rangeProto.compareBoundaryPoints = function(type, range) {
					return this.nativeRange.compareBoundaryPoints(type, range.nativeRange || range);
			};
			}

			/*--------------------------------------------------------------------------------------------------------*/

			// Test for IE 9 deleteContents() and extractContents() bug and correct it. See issue 107.

			var el = document.createElement("div");
			el.innerHTML = "123";
			var textNode = el.firstChild;
			var body = getBody(document);
			body.appendChild(el);

			range.setStart(textNode, 1);
			range.setEnd(textNode, 2);
			range.deleteContents();

			if (textNode.data == "13") {
				// Behaviour is correct per DOM4 Range so wrap the browser's implementation of deleteContents() and
				// extractContents()
			rangeProto.deleteContents = function() {
				this.nativeRange.deleteContents();
				updateRangeProperties(this);
			};

			rangeProto.extractContents = function() {
				var frag = this.nativeRange.extractContents();
				updateRangeProperties(this);
				return frag;
			};
			} else {
			}

			body.removeChild(el);
			body = null;

			/*--------------------------------------------------------------------------------------------------------*/

			// Test for existence of createContextualFragment and delegate to it if it exists
			if (util.isHostMethod(range, "createContextualFragment")) {
				rangeProto.createContextualFragment = function(fragmentStr) {
					return this.nativeRange.createContextualFragment(fragmentStr);
				};
			}

			/*--------------------------------------------------------------------------------------------------------*/

			// Clean up
			getBody(document).removeChild(testTextNode);

			rangeProto.getName = function() {
				return "WrappedRange";
			};

			api.WrappedRange = WrappedRange;

			api.createNativeRange = function(doc) {
				doc = getContentDocument(doc, module, "createNativeRange");
				return doc.createRange();
			};
		})();
	}

	if (api.features.implementsTextRange) {
/*
		This is a workaround for a bug where IE returns the wrong container element from the TextRange's parentElement()
		method. For example, in the following (where pipes denote the selection boundaries):

		<ul id="ul"><li id="a">| a </li><li id="b"> b |</li></ul>

		var range = document.selection.createRange();
		alert(range.parentElement().id); // Should alert "ul" but alerts "b"

		This method returns the common ancestor node of the following:
		- the parentElement() of the textRange
		- the parentElement() of the textRange after calling collapse(true)
		- the parentElement() of the textRange after calling collapse(false)
*/
		var getTextRangeContainerElement = function(textRange) {
			var parentEl = textRange.parentElement();
			var range = textRange.duplicate();
			range.collapse(true);
			var startEl = range.parentElement();
			range = textRange.duplicate();
			range.collapse(false);
			var endEl = range.parentElement();
			var startEndContainer = (startEl == endEl) ? startEl : dom.getCommonAncestor(startEl, endEl);

			return startEndContainer == parentEl ? startEndContainer : dom.getCommonAncestor(parentEl, startEndContainer);
			};

		var textRangeIsCollapsed = function(textRange) {
			return textRange.compareEndPoints("StartToEnd", textRange) == 0;
			};

		// Gets the boundary of a TextRange expressed as a node and an offset within that node. This function started out as
		// an improved version of code found in Tim Cameron Ryan's IERange (http://code.google.com/p/ierange/) but has
		// grown, fixing problems with line breaks in preformatted text, adding workaround for IE TextRange bugs, handling
		// for inputs and images, plus optimizations.
		var getTextRangeBoundaryPosition = function(textRange, wholeRangeContainerElement, isStart, isCollapsed, startInfo) {
			var workingRange = textRange.duplicate();
			workingRange.collapse(isStart);
			var containerElement = workingRange.parentElement();

			// Sometimes collapsing a TextRange that's at the start of a text node can move it into the previous node, so
			// check for that
			if (!dom.isOrIsAncestorOf(wholeRangeContainerElement, containerElement)) {
				containerElement = wholeRangeContainerElement;
			}


			// Deal with nodes that cannot "contain rich HTML markup". In practice, this means form inputs, images and
			// similar. See http://msdn.microsoft.com/en-us/library/aa703950%28VS.85%29.aspx
			if (!containerElement.canHaveHTML) {
				var pos = new DomPosition(containerElement.parentNode, dom.getNodeIndex(containerElement));
				return {
					boundaryPosition: pos,
					nodeInfo: {
						nodeIndex: pos.offset,
						containerElement: pos.node
					}
			};
			}

			var workingNode = dom.getDocument(containerElement).createElement("span");

			// Workaround for HTML5 Shiv's insane violation of document.createElement(). See Rangy issue 104 and HTML5
			// Shiv issue 64: https://github.com/aFarkas/html5shiv/issues/64
			if (workingNode.parentNode) {
				workingNode.parentNode.removeChild(workingNode);
			}

			var comparison, workingComparisonType = isStart ? "StartToStart" : "StartToEnd";
			var previousNode, nextNode, boundaryPosition, boundaryNode;
			var start = (startInfo && startInfo.containerElement == containerElement) ? startInfo.nodeIndex : 0;
			var childNodeCount = containerElement.childNodes.length;
			var end = childNodeCount;

			// Check end first. Code within the loop assumes that the endth child node of the container is definitely
			// after the range boundary.
			var nodeIndex = end;

			while (true) {
				if (nodeIndex == childNodeCount) {
					containerElement.appendChild(workingNode);
				} else {
					containerElement.insertBefore(workingNode, containerElement.childNodes[nodeIndex]);
				}
				workingRange.moveToElementText(workingNode);
				comparison = workingRange.compareEndPoints(workingComparisonType, textRange);
				if (comparison == 0 || start == end) {
					break;
				} else if (comparison == -1) {
					if (end == start + 1) {
						// We know the endth child node is after the range boundary, so we must be done.
						break;
					} else {
						start = nodeIndex;
					}
				} else {
					end = (end == start + 1) ? start : nodeIndex;
				}
				nodeIndex = Math.floor((start + end) / 2);
				containerElement.removeChild(workingNode);
			}


			// We've now reached or gone past the boundary of the text range we're interested in
			// so have identified the node we want
			boundaryNode = workingNode.nextSibling;

			if (comparison == -1 && boundaryNode && isCharacterDataNode(boundaryNode)) {
				// This is a character data node (text, comment, cdata). The working range is collapsed at the start of the
				// node containing the text range's boundary, so we move the end of the working range to the boundary point
				// and measure the length of its text to get the boundary's offset within the node.
				workingRange.setEndPoint(isStart ? "EndToStart" : "EndToEnd", textRange);

				var offset;

				if (/[\r\n]/.test(boundaryNode.data)) {
					/*
					For the particular case of a boundary within a text node containing rendered line breaks (within a <pre>
					element, for example), we need a slightly complicated approach to get the boundary's offset in IE. The
					facts:

					- Each line break is represented as \r in the text node's data/nodeValue properties
					- Each line break is represented as \r\n in the TextRange's 'text' property
					- The 'text' property of the TextRange does not contain trailing line breaks

					To get round the problem presented by the final fact above, we can use the fact that TextRange's
					moveStart() and moveEnd() methods return the actual number of characters moved, which is not necessarily
					the same as the number of characters it was instructed to move. The simplest approach is to use this to
					store the characters moved when moving both the start and end of the range to the start of the document
					body and subtracting the start offset from the end offset (the "move-negative-gazillion" method).
					However, this is extremely slow when the document is large and the range is near the end of it. Clearly
					doing the mirror image (i.e. moving the range boundaries to the end of the document) has the same
					problem.

					Another approach that works is to use moveStart() to move the start boundary of the range up to the end
					boundary one character at a time and incrementing a counter with the value returned by the moveStart()
					call. However, the check for whether the start boundary has reached the end boundary is expensive, so
					this method is slow (although unlike "move-negative-gazillion" is largely unaffected by the location of
					the range within the document).

					The method below is a hybrid of the two methods above. It uses the fact that a string containing the
					TextRange's 'text' property with each \r\n converted to a single \r character cannot be longer than the
					text of the TextRange, so the start of the range is moved that length initially and then a character at
					a time to make up for any trailing line breaks not contained in the 'text' property. This has good
					performance in most situations compared to the previous two methods.
					*/
					var tempRange = workingRange.duplicate();
					var rangeLength = tempRange.text.replace(/\r\n/g, "\r").length;

					offset = tempRange.moveStart("character", rangeLength);
					while ( (comparison = tempRange.compareEndPoints("StartToEnd", tempRange)) == -1) {
						offset++;
						tempRange.moveStart("character", 1);
					}
				} else {
					offset = workingRange.text.length;
					}
				boundaryPosition = new DomPosition(boundaryNode, offset);
			} else {

				// If the boundary immediately follows a character data node and this is the end boundary, we should favour
				// a position within that, and likewise for a start boundary preceding a character data node
				previousNode = (isCollapsed || !isStart) && workingNode.previousSibling;
				nextNode = (isCollapsed || isStart) && workingNode.nextSibling;
				if (nextNode && isCharacterDataNode(nextNode)) {
					boundaryPosition = new DomPosition(nextNode, 0);
				} else if (previousNode && isCharacterDataNode(previousNode)) {
					boundaryPosition = new DomPosition(previousNode, previousNode.data.length);
				} else {
					boundaryPosition = new DomPosition(containerElement, dom.getNodeIndex(workingNode));
				}
					}

			// Clean up
			workingNode.parentNode.removeChild(workingNode);

			return {
				boundaryPosition: boundaryPosition,
				nodeInfo: {
					nodeIndex: nodeIndex,
					containerElement: containerElement
						}
					};
				};

		// Returns a TextRange representing the boundary of a TextRange expressed as a node and an offset within that node.
		// This function started out as an optimized version of code found in Tim Cameron Ryan's IERange
		// (http://code.google.com/p/ierange/)
		var createBoundaryTextRange = function(boundaryPosition, isStart) {
			var boundaryNode, boundaryParent, boundaryOffset = boundaryPosition.offset;
			var doc = dom.getDocument(boundaryPosition.node);
			var workingNode, childNodes, workingRange = getBody(doc).createTextRange();
			var nodeIsDataNode = isCharacterDataNode(boundaryPosition.node);

			if (nodeIsDataNode) {
				boundaryNode = boundaryPosition.node;
				boundaryParent = boundaryNode.parentNode;
			} else {
				childNodes = boundaryPosition.node.childNodes;
				boundaryNode = (boundaryOffset < childNodes.length) ? childNodes[boundaryOffset] : null;
				boundaryParent = boundaryPosition.node;
			}

			// Position the range immediately before the node containing the boundary
			workingNode = doc.createElement("span");

			// Making the working element non-empty element persuades IE to consider the TextRange boundary to be within the
			// element rather than immediately before or after it
			workingNode.innerHTML = "&#feff;";

			// insertBefore is supposed to work like appendChild if the second parameter is null. However, a bug report
			// for IERange suggests that it can crash the browser: http://code.google.com/p/ierange/issues/detail?id=12
			if (boundaryNode) {
				boundaryParent.insertBefore(workingNode, boundaryNode);
			} else {
				boundaryParent.appendChild(workingNode);
			}

			workingRange.moveToElementText(workingNode);
			workingRange.collapse(!isStart);

			// Clean up
			boundaryParent.removeChild(workingNode);

			// Move the working range to the text offset, if required
			if (nodeIsDataNode) {
				workingRange[isStart ? "moveStart" : "moveEnd"]("character", boundaryOffset);
			}

			return workingRange;
				};

		/*------------------------------------------------------------------------------------------------------------*/

		// This is a wrapper around a TextRange, providing full DOM Range functionality using rangy's DomRange as a
		// prototype

		WrappedTextRange = function(textRange) {
			this.textRange = textRange;
			this.refresh();
		};

		WrappedTextRange.prototype = new DomRange(document);

		WrappedTextRange.prototype.refresh = function() {
			var start, end, startBoundary;

			// TextRange's parentElement() method cannot be trusted. getTextRangeContainerElement() works around that.
			var rangeContainerElement = getTextRangeContainerElement(this.textRange);

			if (textRangeIsCollapsed(this.textRange)) {
				end = start = getTextRangeBoundaryPosition(this.textRange, rangeContainerElement, true,
					true).boundaryPosition;
			} else {
				startBoundary = getTextRangeBoundaryPosition(this.textRange, rangeContainerElement, true, false);
				start = startBoundary.boundaryPosition;

				// An optimization used here is that if the start and end boundaries have the same parent element, the
				// search scope for the end boundary can be limited to exclude the portion of the element that precedes
				// the start boundary
				end = getTextRangeBoundaryPosition(this.textRange, rangeContainerElement, false, false,
					startBoundary.nodeInfo).boundaryPosition;
			}

			this.setStart(start.node, start.offset);
			this.setEnd(end.node, end.offset);
		};

		WrappedTextRange.prototype.getName = function() {
			return "WrappedTextRange";
		};

		DomRange.copyComparisonConstants(WrappedTextRange);

		WrappedTextRange.rangeToTextRange = function(range) {
			if (range.collapsed) {
				return createBoundaryTextRange(new DomPosition(range.startContainer, range.startOffset), true);
			} else {
				var startRange = createBoundaryTextRange(new DomPosition(range.startContainer, range.startOffset), true);
				var endRange = createBoundaryTextRange(new DomPosition(range.endContainer, range.endOffset), false);
				var textRange = getBody( DomRange.getRangeDocument(range) ).createTextRange();
				textRange.setEndPoint("StartToStart", startRange);
				textRange.setEndPoint("EndToEnd", endRange);
				return textRange;
			}
		};

		api.WrappedTextRange = WrappedTextRange;

		// IE 9 and above have both implementations and Rangy makes both available. The next few lines sets which
		// implementation to use by default.
		if (!api.features.implementsDomRange || api.config.preferTextRange) {
			// Add WrappedTextRange as the Range property of the global object to allow expression like Range.END_TO_END to work
			var globalObj = (function() { return this; })();
			if (typeof globalObj.Range == "undefined") {
				globalObj.Range = WrappedTextRange;
	}

			api.createNativeRange = function(doc) {
				doc = getContentDocument(doc, module, "createNativeRange");
				return getBody(doc).createTextRange();
	};

			api.WrappedRange = WrappedTextRange;
		}
	}

	api.createRange = function(doc) {
		doc = getContentDocument(doc, module, "createRange");
		return new api.WrappedRange(api.createNativeRange(doc));
	};

	api.createRangyRange = function(doc) {
		doc = getContentDocument(doc, module, "createRangyRange");
		return new DomRange(doc);
	};

	api.createIframeRange = function(iframeEl) {
		module.deprecationNotice("createIframeRange()", "createRange(iframeEl)");
		return api.createRange(iframeEl);
	};

	api.createIframeRangyRange = function(iframeEl) {
		module.deprecationNotice("createIframeRangyRange()", "createRangyRange(iframeEl)");
		return api.createRangyRange(iframeEl);
	};

	api.addCreateMissingNativeApiListener(function(win) {
		var doc = win.document;
		if (typeof doc.createRange == "undefined") {
			doc.createRange = function() {
				return api.createRange(doc);
			};
		}
		doc = win = null;
	});
});
// This module creates a selection object wrapper that conforms as closely as possible to the Selection specification
// in the HTML Editing spec (http://dvcs.w3.org/hg/editing/raw-file/tip/editing.html#selections)
rangy.createCoreModule("WrappedSelection", ["DomRange", "WrappedRange"], function(api, module) {
	api.config.checkSelectionRanges = true;

	var BOOLEAN = "boolean";
	var NUMBER = "number";
	var dom = api.dom;
	var util = api.util;
	var isHostMethod = util.isHostMethod;
	var DomRange = api.DomRange;
	var WrappedRange = api.WrappedRange;
	var DOMException = api.DOMException;
	var DomPosition = dom.DomPosition;
	var getNativeSelection;
	var selectionIsCollapsed;
	var features = api.features;
	var CONTROL = "Control";
	var getDocument = dom.getDocument;
	var getBody = dom.getBody;
	var rangesEqual = DomRange.rangesEqual;


	// Utility function to support direction parameters in the API that may be a string ("backward" or "forward") or a
	// Boolean (true for backwards).
	function isDirectionBackward(dir) {
		return (typeof dir == "string") ? /^backward(s)?$/i.test(dir) : !!dir;
	}

	function getWindow(win, methodName) {
		if (!win) {
			return window;
		} else if (dom.isWindow(win)) {
			return win;
		} else if (win instanceof WrappedSelection) {
			return win.win;
		} else {
			var doc = dom.getContentDocument(win, module, methodName);
			return dom.getWindow(doc);
		}
	}

	function getWinSelection(winParam) {
		return getWindow(winParam, "getWinSelection").getSelection();
	}

	function getDocSelection(winParam) {
		return getWindow(winParam, "getDocSelection").document.selection;
	}
	
	function winSelectionIsBackward(sel) {
		var backward = false;
		if (sel.anchorNode) {
			backward = (dom.comparePoints(sel.anchorNode, sel.anchorOffset, sel.focusNode, sel.focusOffset) == 1);
		}
		return backward;
	}

	// Test for the Range/TextRange and Selection features required
	// Test for ability to retrieve selection
	var implementsWinGetSelection = isHostMethod(window, "getSelection"),
		implementsDocSelection = util.isHostObject(document, "selection");

	features.implementsWinGetSelection = implementsWinGetSelection;
	features.implementsDocSelection = implementsDocSelection;

	var useDocumentSelection = implementsDocSelection && (!implementsWinGetSelection || api.config.preferTextRange);

	if (useDocumentSelection) {
		getNativeSelection = getDocSelection;
		api.isSelectionValid = function(winParam) {
			var doc = getWindow(winParam, "isSelectionValid").document, nativeSel = doc.selection;

			// Check whether the selection TextRange is actually contained within the correct document
			return (nativeSel.type != "None" || getDocument(nativeSel.createRange().parentElement()) == doc);
		};
	} else if (implementsWinGetSelection) {
		getNativeSelection = getWinSelection;
		api.isSelectionValid = function() {
			return true;
		};
	} else {
		module.fail("Neither document.selection or window.getSelection() detected.");
	}

	api.getNativeSelection = getNativeSelection;

	var testSelection = getNativeSelection();
	var testRange = api.createNativeRange(document);
	var body = getBody(document);

	// Obtaining a range from a selection
	var selectionHasAnchorAndFocus = util.areHostProperties(testSelection,
		["anchorNode", "focusNode", "anchorOffset", "focusOffset"]);

	features.selectionHasAnchorAndFocus = selectionHasAnchorAndFocus;

	// Test for existence of native selection extend() method
	var selectionHasExtend = isHostMethod(testSelection, "extend");
	features.selectionHasExtend = selectionHasExtend;

	// Test if rangeCount exists
	var selectionHasRangeCount = (typeof testSelection.rangeCount == NUMBER);
	features.selectionHasRangeCount = selectionHasRangeCount;

	var selectionSupportsMultipleRanges = false;
	var collapsedNonEditableSelectionsSupported = true;

	var addRangeBackwardToNative = selectionHasExtend ?
		function(nativeSelection, range) {
			var doc = DomRange.getRangeDocument(range);
			var endRange = api.createRange(doc);
			endRange.collapseToPoint(range.endContainer, range.endOffset);
			nativeSelection.addRange(getNativeRange(endRange));
			nativeSelection.extend(range.startContainer, range.startOffset);
		} : null;

	if (util.areHostMethods(testSelection, ["addRange", "getRangeAt", "removeAllRanges"]) &&
			typeof testSelection.rangeCount == NUMBER && features.implementsDomRange) {

		(function() {
			// Previously an iframe was used but this caused problems in some circumstances in IE, so tests are
			// performed on the current document's selection. See issue 109.

			// Note also that if a selection previously existed, it is wiped by these tests. This should usually be fine
			// because initialization usually happens when the document loads, but could be a problem for a script that
			// loads and initializes Rangy later. If anyone complains, code could be added to save and restore the
			// selection.
			var sel = window.getSelection();
			if (sel) {
				// Store the current selection
				var originalSelectionRangeCount = sel.rangeCount;
				var selectionHasMultipleRanges = (originalSelectionRangeCount > 1);
				var originalSelectionRanges = [];
				var originalSelectionBackward = winSelectionIsBackward(sel); 
				for (var i = 0; i < originalSelectionRangeCount; ++i) {
					originalSelectionRanges[i] = sel.getRangeAt(i);
				}
				
				// Create some test elements
				var body = getBody(document);
				var testEl = body.appendChild( document.createElement("div") );
				testEl.contentEditable = "false";
				var textNode = testEl.appendChild( document.createTextNode("\u00a0\u00a0\u00a0") );

			// Test whether the native selection will allow a collapsed selection within a non-editable element
				var r1 = document.createRange();

			r1.setStart(textNode, 1);
			r1.collapse(true);
			sel.addRange(r1);
			collapsedNonEditableSelectionsSupported = (sel.rangeCount == 1);
			sel.removeAllRanges();

			// Test whether the native selection is capable of supporting multiple ranges
				if (!selectionHasMultipleRanges) {
			var r2 = r1.cloneRange();
			r1.setStart(textNode, 0);
					r2.setEnd(textNode, 3);
					r2.setStart(textNode, 2);
			sel.addRange(r1);

                    // Next line causes Chrome 36 to print a console error of
                    // "Discontiguous selection is not supported.".
                    // https://code.google.com/p/chromium/issues/detail?id=353069#c4
			sel.addRange(r2);

			selectionSupportsMultipleRanges = (sel.rangeCount == 2);
					r2.detach();
				}

			// Clean up
				body.removeChild(testEl);
				sel.removeAllRanges();

				for (i = 0; i < originalSelectionRangeCount; ++i) {
					if (i == 0 && originalSelectionBackward) {
						if (addRangeBackwardToNative) {
							addRangeBackwardToNative(sel, originalSelectionRanges[i]);
						} else {
                            api.warn("Rangy initialization: original selection was backwards but selection has been restored forwards because the browser does not support Selection.extend");
                            sel.addRange(originalSelectionRanges[i]);
						}
					} else {
                        sel.addRange(originalSelectionRanges[i]);
					}
				}
			}
		})();
	}

	features.selectionSupportsMultipleRanges = selectionSupportsMultipleRanges;
	features.collapsedNonEditableSelectionsSupported = collapsedNonEditableSelectionsSupported;

	// ControlRanges
	var implementsControlRange = false, testControlRange;

	if (body && isHostMethod(body, "createControlRange")) {
		testControlRange = body.createControlRange();
		if (util.areHostProperties(testControlRange, ["item", "add"])) {
			implementsControlRange = true;
		}
	}
	features.implementsControlRange = implementsControlRange;

	// Selection collapsedness
	if (selectionHasAnchorAndFocus) {
		selectionIsCollapsed = function(sel) {
			return sel.anchorNode === sel.focusNode && sel.anchorOffset === sel.focusOffset;
		};
	} else {
		selectionIsCollapsed = function(sel) {
			return sel.rangeCount ? sel.getRangeAt(sel.rangeCount - 1).collapsed : false;
		};
	}

	function updateAnchorAndFocusFromRange(sel, range, backward) {
		var anchorPrefix = backward ? "end" : "start", focusPrefix = backward ? "start" : "end";
		sel.anchorNode = range[anchorPrefix + "Container"];
		sel.anchorOffset = range[anchorPrefix + "Offset"];
		sel.focusNode = range[focusPrefix + "Container"];
		sel.focusOffset = range[focusPrefix + "Offset"];
	}

	function updateAnchorAndFocusFromNativeSelection(sel) {
		var nativeSel = sel.nativeSelection;
		sel.anchorNode = nativeSel.anchorNode;
		sel.anchorOffset = nativeSel.anchorOffset;
		sel.focusNode = nativeSel.focusNode;
		sel.focusOffset = nativeSel.focusOffset;
	}

	function updateEmptySelection(sel) {
		sel.anchorNode = sel.focusNode = null;
		sel.anchorOffset = sel.focusOffset = 0;
		sel.rangeCount = 0;
		sel.isCollapsed = true;
		sel._ranges.length = 0;
	}

	function getNativeRange(range) {
		var nativeRange;
		if (range instanceof DomRange) {
			nativeRange = api.createNativeRange(range.getDocument());
				nativeRange.setEnd(range.endContainer, range.endOffset);
				nativeRange.setStart(range.startContainer, range.startOffset);
		} else if (range instanceof WrappedRange) {
			nativeRange = range.nativeRange;
		} else if (features.implementsDomRange && (range instanceof dom.getWindow(range.startContainer).Range)) {
			nativeRange = range;
		}
		return nativeRange;
	}

	function rangeContainsSingleElement(rangeNodes) {
		if (!rangeNodes.length || rangeNodes[0].nodeType != 1) {
			return false;
		}
		for (var i = 1, len = rangeNodes.length; i < len; ++i) {
			if (!dom.isAncestorOf(rangeNodes[0], rangeNodes[i])) {
				return false;
			}
		}
		return true;
	}

	function getSingleElementFromRange(range) {
		var nodes = range.getNodes();
		if (!rangeContainsSingleElement(nodes)) {
			throw module.createError("getSingleElementFromRange: range " + range.inspect() + " did not consist of a single element");
		}
		return nodes[0];
	}

	// Simple, quick test which only needs to distinguish between a TextRange and a ControlRange
	function isTextRange(range) {
		return !!range && typeof range.text != "undefined";
	}

	function updateFromTextRange(sel, range) {
		// Create a Range from the selected TextRange
		var wrappedRange = new WrappedRange(range);
		sel._ranges = [wrappedRange];

		updateAnchorAndFocusFromRange(sel, wrappedRange, false);
		sel.rangeCount = 1;
		sel.isCollapsed = wrappedRange.collapsed;
	}

	function updateControlSelection(sel) {
		// Update the wrapped selection based on what's now in the native selection
		sel._ranges.length = 0;
		if (sel.docSelection.type == "None") {
			updateEmptySelection(sel);
		} else {
			var controlRange = sel.docSelection.createRange();
			if (isTextRange(controlRange)) {
				// This case (where the selection type is "Control" and calling createRange() on the selection returns
				// a TextRange) can happen in IE 9. It happens, for example, when all elements in the selected
				// ControlRange have been removed from the ControlRange and removed from the document.
				updateFromTextRange(sel, controlRange);
			} else {
				sel.rangeCount = controlRange.length;
				var range, doc = getDocument(controlRange.item(0));
				for (var i = 0; i < sel.rangeCount; ++i) {
					range = api.createRange(doc);
					range.selectNode(controlRange.item(i));
					sel._ranges.push(range);
				}
				sel.isCollapsed = sel.rangeCount == 1 && sel._ranges[0].collapsed;
				updateAnchorAndFocusFromRange(sel, sel._ranges[sel.rangeCount - 1], false);
			}
		}
	}

	function addRangeToControlSelection(sel, range) {
		var controlRange = sel.docSelection.createRange();
		var rangeElement = getSingleElementFromRange(range);

		// Create a new ControlRange containing all the elements in the selected ControlRange plus the element
		// contained by the supplied range
		var doc = getDocument(controlRange.item(0));
		var newControlRange = getBody(doc).createControlRange();
		for (var i = 0, len = controlRange.length; i < len; ++i) {
			newControlRange.add(controlRange.item(i));
		}
		try {
			newControlRange.add(rangeElement);
		} catch (ex) {
			throw module.createError("addRange(): Element within the specified Range could not be added to control selection (does it have layout?)");
		}
		newControlRange.select();

		// Update the wrapped selection based on what's now in the native selection
		updateControlSelection(sel);
	}

	var getSelectionRangeAt;

	if (isHostMethod(testSelection, "getRangeAt")) {
		// try/catch is present because getRangeAt() must have thrown an error in some browser and some situation.
		// Unfortunately, I didn't write a comment about the specifics and am now scared to take it out. Let that be a
		// lesson to us all, especially me.
		getSelectionRangeAt = function(sel, index) {
			try {
				return sel.getRangeAt(index);
			} catch(ex) {
				return null;
			}
		};
	} else if (selectionHasAnchorAndFocus) {
		getSelectionRangeAt = function(sel) {
			var doc = getDocument(sel.anchorNode);
			var range = api.createRange(doc);
			range.setStartAndEnd(sel.anchorNode, sel.anchorOffset, sel.focusNode, sel.focusOffset);

			// Handle the case when the selection was selected backwards (from the end to the start in the
			// document)
			if (range.collapsed !== this.isCollapsed) {
				range.setStartAndEnd(sel.focusNode, sel.focusOffset, sel.anchorNode, sel.anchorOffset);
			}

			return range;
		};
	}

	function WrappedSelection(selection, docSelection, win) {
		this.nativeSelection = selection;
		this.docSelection = docSelection;
		this._ranges = [];
		this.win = win;
		this.refresh();
	}

	WrappedSelection.prototype = api.selectionPrototype;

	function deleteProperties(sel) {
		sel.win = sel.anchorNode = sel.focusNode = sel._ranges = null;
		sel.rangeCount = sel.anchorOffset = sel.focusOffset = 0;
		sel.detached = true;
	}

	var cachedRangySelections = [];

	function actOnCachedSelection(win, action) {
		var i = cachedRangySelections.length, cached, sel;
		while (i--) {
			cached = cachedRangySelections[i];
			sel = cached.selection;
			if (action == "deleteAll") {
				deleteProperties(sel);
			} else if (cached.win == win) {
				if (action == "delete") {
					cachedRangySelections.splice(i, 1);
					return true;
				} else {
					return sel;
				}
			}
		}
		if (action == "deleteAll") {
			cachedRangySelections.length = 0;
		}
		return null;
	}

	var getSelection = function(win) {
		// Check if the parameter is a Rangy Selection object
		if (win && win instanceof WrappedSelection) {
			win.refresh();
			return win;
		}

		win = getWindow(win, "getNativeSelection");

		var sel = actOnCachedSelection(win);
		var nativeSel = getNativeSelection(win), docSel = implementsDocSelection ? getDocSelection(win) : null;
		if (sel) {
			sel.nativeSelection = nativeSel;
			sel.docSelection = docSel;
			sel.refresh();
		} else {
			sel = new WrappedSelection(nativeSel, docSel, win);
			cachedRangySelections.push( { win: win, selection: sel } );
		}
		return sel;
	};

	api.getSelection = getSelection;

	api.getIframeSelection = function(iframeEl) {
		module.deprecationNotice("getIframeSelection()", "getSelection(iframeEl)");
		return api.getSelection(dom.getIframeWindow(iframeEl));
	};

	var selProto = WrappedSelection.prototype;

	function createControlSelection(sel, ranges) {
		// Ensure that the selection becomes of type "Control"
		var doc = getDocument(ranges[0].startContainer);
		var controlRange = getBody(doc).createControlRange();
		for (var i = 0, el, len = ranges.length; i < len; ++i) {
			el = getSingleElementFromRange(ranges[i]);
			try {
				controlRange.add(el);
			} catch (ex) {
				throw module.createError("setRanges(): Element within one of the specified Ranges could not be added to control selection (does it have layout?)");
			}
		}
		controlRange.select();

		// Update the wrapped selection based on what's now in the native selection
		updateControlSelection(sel);
	}

	// Selecting a range
	if (!useDocumentSelection && selectionHasAnchorAndFocus && util.areHostMethods(testSelection, ["removeAllRanges", "addRange"])) {
		selProto.removeAllRanges = function() {
			this.nativeSelection.removeAllRanges();
			updateEmptySelection(this);
		};

		var addRangeBackward = function(sel, range) {
			addRangeBackwardToNative(sel.nativeSelection, range);
			sel.refresh();
		};

		if (selectionHasRangeCount) {
			selProto.addRange = function(range, direction) {
				if (implementsControlRange && implementsDocSelection && this.docSelection.type == CONTROL) {
					addRangeToControlSelection(this, range);
				} else {
					if (isDirectionBackward(direction) && selectionHasExtend) {
						addRangeBackward(this, range);
					} else {
						var previousRangeCount;
						if (selectionSupportsMultipleRanges) {
							previousRangeCount = this.rangeCount;
						} else {
							this.removeAllRanges();
							previousRangeCount = 0;
						}
						// Clone the native range so that changing the selected range does not affect the selection.
						// This is contrary to the spec but is the only way to achieve consistency between browsers. See
						// issue 80.
						this.nativeSelection.addRange(getNativeRange(range).cloneRange());

						// Check whether adding the range was successful
						this.rangeCount = this.nativeSelection.rangeCount;

						if (this.rangeCount == previousRangeCount + 1) {
							// The range was added successfully

							// Check whether the range that we added to the selection is reflected in the last range extracted from
							// the selection
							if (api.config.checkSelectionRanges) {
								var nativeRange = getSelectionRangeAt(this.nativeSelection, this.rangeCount - 1);
								if (nativeRange && !rangesEqual(nativeRange, range)) {
									// Happens in WebKit with, for example, a selection placed at the start of a text node
									range = new WrappedRange(nativeRange);
								}
							}
							this._ranges[this.rangeCount - 1] = range;
							updateAnchorAndFocusFromRange(this, range, selectionIsBackward(this.nativeSelection));
							this.isCollapsed = selectionIsCollapsed(this);
						} else {
							// The range was not added successfully. The simplest thing is to refresh
							this.refresh();
						}
					}
				}
			};
		} else {
			selProto.addRange = function(range, direction) {
				if (isDirectionBackward(direction) && selectionHasExtend) {
					addRangeBackward(this, range);
				} else {
					this.nativeSelection.addRange(getNativeRange(range));
					this.refresh();
				}
			};
		}

		selProto.setRanges = function(ranges) {
			if (implementsControlRange && ranges.length > 1) {
				createControlSelection(this, ranges);
			} else {
				this.removeAllRanges();
				for (var i = 0, len = ranges.length; i < len; ++i) {
					this.addRange(ranges[i]);
				}
			}
		};
	} else if (isHostMethod(testSelection, "empty") && isHostMethod(testRange, "select") &&
			   implementsControlRange && useDocumentSelection) {

		selProto.removeAllRanges = function() {
			// Added try/catch as fix for issue #21
			try {
				this.docSelection.empty();

				// Check for empty() not working (issue #24)
				if (this.docSelection.type != "None") {
					// Work around failure to empty a control selection by instead selecting a TextRange and then
					// calling empty()
					var doc;
					if (this.anchorNode) {
						doc = getDocument(this.anchorNode);
					} else if (this.docSelection.type == CONTROL) {
						var controlRange = this.docSelection.createRange();
						if (controlRange.length) {
							doc = getDocument( controlRange.item(0) );
						}
					}
					if (doc) {
						var textRange = getBody(doc).createTextRange();
						textRange.select();
						this.docSelection.empty();
					}
				}
			} catch(ex) {}
			updateEmptySelection(this);
		};

		selProto.addRange = function(range) {
			if (this.docSelection.type == CONTROL) {
				addRangeToControlSelection(this, range);
			} else {
				api.WrappedTextRange.rangeToTextRange(range).select();
				this._ranges[0] = range;
				this.rangeCount = 1;
				this.isCollapsed = this._ranges[0].collapsed;
				updateAnchorAndFocusFromRange(this, range, false);
			}
		};

		selProto.setRanges = function(ranges) {
			this.removeAllRanges();
			var rangeCount = ranges.length;
			if (rangeCount > 1) {
				createControlSelection(this, ranges);
			} else if (rangeCount) {
				this.addRange(ranges[0]);
			}
		};
	} else {
		module.fail("No means of selecting a Range or TextRange was found");
		return false;
	}

	selProto.getRangeAt = function(index) {
		if (index < 0 || index >= this.rangeCount) {
			throw new DOMException("INDEX_SIZE_ERR");
		} else {
			// Clone the range to preserve selection-range independence. See issue 80.
			return this._ranges[index].cloneRange();
		}
	};

	var refreshSelection;

	if (useDocumentSelection) {
		refreshSelection = function(sel) {
			var range;
			if (api.isSelectionValid(sel.win)) {
				range = sel.docSelection.createRange();
			} else {
				range = getBody(sel.win.document).createTextRange();
				range.collapse(true);
			}

			if (sel.docSelection.type == CONTROL) {
				updateControlSelection(sel);
			} else if (isTextRange(range)) {
				updateFromTextRange(sel, range);
			} else {
				updateEmptySelection(sel);
			}
		};
	} else if (isHostMethod(testSelection, "getRangeAt") && typeof testSelection.rangeCount == NUMBER) {
		refreshSelection = function(sel) {
			if (implementsControlRange && implementsDocSelection && sel.docSelection.type == CONTROL) {
				updateControlSelection(sel);
			} else {
                sel._ranges.length = sel.rangeCount = sel.nativeSelection.rangeCount;
				if (sel.rangeCount) {
					for (var i = 0, len = sel.rangeCount; i < len; ++i) {
						sel._ranges[i] = new api.WrappedRange(sel.nativeSelection.getRangeAt(i));
					}
					updateAnchorAndFocusFromRange(sel, sel._ranges[sel.rangeCount - 1], selectionIsBackward(sel.nativeSelection));
					sel.isCollapsed = selectionIsCollapsed(sel);
				} else {
					updateEmptySelection(sel);
				}
			}
		};
	} else if (selectionHasAnchorAndFocus && typeof testSelection.isCollapsed == BOOLEAN && typeof testRange.collapsed == BOOLEAN && features.implementsDomRange) {
		refreshSelection = function(sel) {
			var range, nativeSel = sel.nativeSelection;
			if (nativeSel.anchorNode) {
				range = getSelectionRangeAt(nativeSel, 0);
				sel._ranges = [range];
				sel.rangeCount = 1;
				updateAnchorAndFocusFromNativeSelection(sel);
				sel.isCollapsed = selectionIsCollapsed(sel);
			} else {
				updateEmptySelection(sel);
			}
		};
	} else {
		module.fail("No means of obtaining a Range or TextRange from the user's selection was found");
		return false;
	}

	selProto.refresh = function(checkForChanges) {
		var oldRanges = checkForChanges ? this._ranges.slice(0) : null;
		var oldAnchorNode = this.anchorNode, oldAnchorOffset = this.anchorOffset;

		refreshSelection(this);
		if (checkForChanges) {
			// Check the range count first
			var i = oldRanges.length;
			if (i != this._ranges.length) {
				return true;
			}

			// Now check the direction. Checking the anchor position is the same is enough since we're checking all the
			// ranges after this
			if (this.anchorNode != oldAnchorNode || this.anchorOffset != oldAnchorOffset) {
				return true;
			}

			// Finally, compare each range in turn
			while (i--) {
				if (!rangesEqual(oldRanges[i], this._ranges[i])) {
					return true;
				}
			}
			return false;
		}
	};

	// Removal of a single range
	var removeRangeManually = function(sel, range) {
		var ranges = sel.getAllRanges();
		sel.removeAllRanges();
		for (var i = 0, len = ranges.length; i < len; ++i) {
			if (!rangesEqual(range, ranges[i])) {
				sel.addRange(ranges[i]);
			}
		}
		if (!sel.rangeCount) {
			updateEmptySelection(sel);
		}
	};

	if (implementsControlRange) {
		selProto.removeRange = function(range) {
			if (this.docSelection.type == CONTROL) {
				var controlRange = this.docSelection.createRange();
				var rangeElement = getSingleElementFromRange(range);

				// Create a new ControlRange containing all the elements in the selected ControlRange minus the
				// element contained by the supplied range
				var doc = getDocument(controlRange.item(0));
				var newControlRange = getBody(doc).createControlRange();
				var el, removed = false;
				for (var i = 0, len = controlRange.length; i < len; ++i) {
					el = controlRange.item(i);
					if (el !== rangeElement || removed) {
						newControlRange.add(controlRange.item(i));
					} else {
						removed = true;
					}
				}
				newControlRange.select();

				// Update the wrapped selection based on what's now in the native selection
				updateControlSelection(this);
			} else {
				removeRangeManually(this, range);
			}
		};
	} else {
		selProto.removeRange = function(range) {
			removeRangeManually(this, range);
		};
	}

	// Detecting if a selection is backward
	var selectionIsBackward;
	if (!useDocumentSelection && selectionHasAnchorAndFocus && features.implementsDomRange) {
		selectionIsBackward = winSelectionIsBackward;

		selProto.isBackward = function() {
			return selectionIsBackward(this);
		};
	} else {
		selectionIsBackward = selProto.isBackward = function() {
			return false;
		};
	}

	// Create an alias for backwards compatibility. From 1.3, everything is "backward" rather than "backwards"
	selProto.isBackwards = selProto.isBackward;

	// Selection stringifier
	// This is conformant to the old HTML5 selections draft spec but differs from WebKit and Mozilla's implementation.
	// The current spec does not yet define this method.
	selProto.toString = function() {
		var rangeTexts = [];
		for (var i = 0, len = this.rangeCount; i < len; ++i) {
			rangeTexts[i] = "" + this._ranges[i];
		}
		return rangeTexts.join("");
	};

	function assertNodeInSameDocument(sel, node) {
		if (sel.win.document != getDocument(node)) {
			throw new DOMException("WRONG_DOCUMENT_ERR");
		}
	}

	// No current browser conforms fully to the spec for this method, so Rangy's own method is always used
	selProto.collapse = function(node, offset) {
		assertNodeInSameDocument(this, node);
		var range = api.createRange(node);
		range.collapseToPoint(node, offset);
		this.setSingleRange(range);
		this.isCollapsed = true;
	};

	selProto.collapseToStart = function() {
		if (this.rangeCount) {
			var range = this._ranges[0];
			this.collapse(range.startContainer, range.startOffset);
		} else {
			throw new DOMException("INVALID_STATE_ERR");
		}
	};

	selProto.collapseToEnd = function() {
		if (this.rangeCount) {
			var range = this._ranges[this.rangeCount - 1];
			this.collapse(range.endContainer, range.endOffset);
		} else {
			throw new DOMException("INVALID_STATE_ERR");
		}
	};

	// The spec is very specific on how selectAllChildren should be implemented so the native implementation is
	// never used by Rangy.
	selProto.selectAllChildren = function(node) {
		assertNodeInSameDocument(this, node);
		var range = api.createRange(node);
		range.selectNodeContents(node);
		this.setSingleRange(range);
	};

	selProto.deleteFromDocument = function() {
		// Sepcial behaviour required for IE's control selections
		if (implementsControlRange && implementsDocSelection && this.docSelection.type == CONTROL) {
			var controlRange = this.docSelection.createRange();
			var element;
			while (controlRange.length) {
				element = controlRange.item(0);
				controlRange.remove(element);
				element.parentNode.removeChild(element);
			}
			this.refresh();
		} else if (this.rangeCount) {
			var ranges = this.getAllRanges();
			if (ranges.length) {
			this.removeAllRanges();
			for (var i = 0, len = ranges.length; i < len; ++i) {
				ranges[i].deleteContents();
			}
				// The spec says nothing about what the selection should contain after calling deleteContents on each
			// range. Firefox moves the selection to where the final selected range was, so we emulate that
			this.addRange(ranges[len - 1]);
		}
		}
	};

	// The following are non-standard extensions
	selProto.eachRange = function(func, returnValue) {
		for (var i = 0, len = this._ranges.length; i < len; ++i) {
			if ( func( this.getRangeAt(i) ) ) {
				return returnValue;
			}
		}
	};

	selProto.getAllRanges = function() {
		var ranges = [];
		this.eachRange(function(range) {
			ranges.push(range);
		});
		return ranges;
	};

	selProto.setSingleRange = function(range, direction) {
		this.removeAllRanges();
		this.addRange(range, direction);
	};

	selProto.callMethodOnEachRange = function(methodName, params) {
		var results = [];
		this.eachRange( function(range) {
			results.push( range[methodName].apply(range, params) );
		} );
		return results;
	};

	function createStartOrEndSetter(isStart) {
		return function(node, offset) {
			var range;
			if (this.rangeCount) {
				range = this.getRangeAt(0);
				range["set" + (isStart ? "Start" : "End")](node, offset);
			} else {
				range = api.createRange(this.win.document);
				range.setStartAndEnd(node, offset);
			}
			this.setSingleRange(range, this.isBackward());
		};
	}

	selProto.setStart = createStartOrEndSetter(true);
	selProto.setEnd = createStartOrEndSetter(false);
	
	// Add select() method to Range prototype. Any existing selection will be removed.
	api.rangePrototype.select = function(direction) {
		getSelection( this.getDocument() ).setSingleRange(this, direction);
	};

	selProto.changeEachRange = function(func) {
		var ranges = [];
		var backward = this.isBackward();

		this.eachRange(function(range) {
			func(range);
			ranges.push(range);
		});

		this.removeAllRanges();
		if (backward && ranges.length == 1) {
			this.addRange(ranges[0], "backward");
		} else {
			this.setRanges(ranges);
		}
	};

	selProto.containsNode = function(node, allowPartial) {
		return this.eachRange( function(range) {
			return range.containsNode(node, allowPartial);
		}, true );
	};

	selProto.getBookmark = function(containerNode) {
		return {
			backward: this.isBackward(),
			rangeBookmarks: this.callMethodOnEachRange("getBookmark", [containerNode])
		};
	};

	selProto.moveToBookmark = function(bookmark) {
		var selRanges = [];
		for (var i = 0, rangeBookmark, range; rangeBookmark = bookmark.rangeBookmarks[i++]; ) {
			range = api.createRange(this.win);
			range.moveToBookmark(rangeBookmark);
			selRanges.push(range);
			}
		if (bookmark.backward) {
			this.setSingleRange(selRanges[0], "backward");
		} else {
			this.setRanges(selRanges);
		}
	};

	selProto.toHtml = function() {
		return this.callMethodOnEachRange("toHtml").join("");
	};

	function inspect(sel) {
		var rangeInspects = [];
		var anchor = new DomPosition(sel.anchorNode, sel.anchorOffset);
		var focus = new DomPosition(sel.focusNode, sel.focusOffset);
		var name = (typeof sel.getName == "function") ? sel.getName() : "Selection";

		if (typeof sel.rangeCount != "undefined") {
			for (var i = 0, len = sel.rangeCount; i < len; ++i) {
				rangeInspects[i] = DomRange.inspect(sel.getRangeAt(i));
			}
		}
		return "[" + name + "(Ranges: " + rangeInspects.join(", ") +
				")(anchor: " + anchor.inspect() + ", focus: " + focus.inspect() + "]";
	}

	selProto.getName = function() {
		return "WrappedSelection";
	};

	selProto.inspect = function() {
		return inspect(this);
	};

	selProto.detach = function() {
		actOnCachedSelection(this.win, "delete");
		deleteProperties(this);
	};

	WrappedSelection.detachAll = function() {
		actOnCachedSelection(null, "deleteAll");
	};

	WrappedSelection.inspect = inspect;
	WrappedSelection.isDirectionBackward = isDirectionBackward;

	api.Selection = WrappedSelection;

	api.selectionPrototype = selProto;

	api.addCreateMissingNativeApiListener(function(win) {
		if (typeof win.getSelection == "undefined") {
			win.getSelection = function() {
				return getSelection(win);
			};
		}
		win = null;
	});
});
(function () {
	/**
	 * TODO
	 * 1. Each time an ice node is removed, refresh change set
	 */


	var exports = this,
		defaults, InlineChangeEditor;

	defaults = {
	// ice node attribute names:
		attributes: {
			changeId: 'data-cid',
			userId: 'data-userid',
			userName: 'data-username',
			time: 'data-time',
			changeData: 'data-changedata', // dfl, arbitrary data to associate with the node, e.g. version
		},
		// Prepended to `changeType.alias` for classname uniqueness, if needed
		attrValuePrefix: '',
		
		// Block element tagname, which wrap text and other inline nodes in `this.element`
		blockEl: 'p',
		
		// All permitted block element tagnames
		blockEls: ['div','p', 'ol', 'ul', 'li', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'blockquote'],
		
		// Unique style prefix, prepended to a digit, incremented for each encountered user, and stored
		// in ice node class attributes - cts1, cts2, cts3, ...
		stylePrefix: 'cts',
		currentUser: {
			id: null,
			name: null
		},
	
		// Default change types are insert and delete. Plugins or outside apps should extend this
		// if they want to manage new change types. The changeType name is used as a primary
		// reference for ice nodes; the `alias`, is dropped in the class attribute and is the
		// primary method of identifying ice nodes; and `tag` is used for construction only.
		// Invoking `this.getCleanContent()` will remove all delete type nodes and remove the tags
		// for the other types, leaving the html content in place.
		changeTypes: {
			insertType: {
				tag: 'span',
				alias: 'ins',
				action: 'Inserted'
		},
			deleteType: {
				tag: 'span',
				alias: 'del',
				action: 'Deleted'
			}
		},

		// If true, setup event listeners on `this.element` and handle events - good option for a basic
		// setup without a text editor. Otherwise, when set to false, events need to be manually passed
		// to _handleEvent, which is good for a text editor with an event callback handler, like tinymce.
		handleEvents: false,
	
		// Sets this.element with the contentEditable element
		contentEditable: undefined,//dfl, start with a neutral value
	
		// Switch for toggling track changes on/off - when `false` events will be ignored.
		_isTracking: true,
	
		// NOT IMPLEMENTED - Selector for elements that will not get track changes
		noTrack: '.ice-no-track',
		
		tooltips: false, //dfl
		
		tooltipsDelay: 200, //dfl
	
		// Switch for whether paragraph breaks should be removed when the user is deleting over a
		// paragraph break while changes are tracked.
		mergeBlocks: true,
		
		_isVisible : true, // dfl, state of change tracking visibility
		
		_changeData : null, //dfl, a string you can associate with the current change set, e.g. version
		
		_handleSelectAll: false, // dfl, if true, handle ctrl/cmd-A in the change tracker
	};

	/**
	 * @class ice.InlineChangeEditor
	 * The change tracking engine
	 * interacts with a <code>contenteditable</code> DOM element
	 */
	InlineChangeEditor = function (options) {

		// Data structure for modelling changes in the element according to the following model:
		//	[changeid] => {`type`, `time`, `userid`, `username`}
		options || (options = {});
		if (!options.element) {
			throw new Error("options.element must be defined for ice construction.");
		}
	
		this._changes = {};
		// Tracks all of the styles for users according to the following model:
		//	[userId] => styleId; where style is "this.stylePrefix" + "this.uniqueStyleIndex"
		this._userStyles = {};
		this._styles = {}; // dfl, moved from prototype
		this._refreshInterval = null; // dfl
		this.$this = jQuery(this);
		this._browser = ice.dom.browser();
		this._tooltipMouseOver = this._tooltipMouseOver.bind(this);
		this._tooltipMouseOut = this._tooltipMouseOut.bind(this);
		
		ice.dom.extend(true, this, defaults, options);
		if (options.tooltips && (! jQuery.isFunction(options.hostMethods.showTooltip) || ! jQuery.isFunction(options.hostMethods.hideTooltip))) {
			throw new Error("hostMethods.showTooltip and hostMethods.hideTooltip must be defined if tooltips is true");
		}
		var us = options.userStyles || {}; // dfl, moved from prototype, allow preconfig
		for (var id in us) {
			if (us.hasOwnProperty(id)) {
				var st = us[id];
				if (! isNaN(st)) {
					this._userStyles[id] = this.stylePrefix + '-' + st;
					this._uniqueStyleIndex = Math.max(st, this._uniqueStyleIndex);
					this._styles[st] = true;
				}
			}
		}
		logError = options.logError || function(){};
	};

	InlineChangeEditor.prototype = {
	
		// Incremented for each new user and appended to they style prefix, and dropped in the
		// ice node class attribute.
		_uniqueStyleIndex: 0,
	
		_browserType: null,
	
		// One change may create multiple ice nodes, so this keeps track of the current batch id.
		_batchChangeId: null,
	
		// Incremented for each new change, dropped in the changeIdAttribute.
		_uniqueIDIndex: 1,
	
		// Temporary bookmark tags for deletes, when delete placeholding is active.
		_delBookmark: 'tempdel',
		isPlaceHoldingDeletes: false,
	
		/**
		 * Turns on change tracking - sets up events, if needed, and initializes the environment,
		 * range, and editor.
		 */
		startTracking: function () {
			// dfl:set contenteditable only if it has been explicitly set
			if (typeof(this.contentEditable) == "boolean") {
				this.element.setAttribute('contentEditable', this.contentEditable);
			}
		
			// If we are handling events setup the delegate to handle various events on `this.element`.
			if (this.handleEvents) {
				var self = this;
				ice.dom.bind(self.element, 'keyup.ice keydown.ice keypress.ice', function (e) {
					return self._handleEvent(e);
				});
			}
			
			this.initializeEnvironment();
			this.initializeEditor();
			this.initializeRange();
			this._updateTooltipsState(); //dfl
			
			return this;
		},
	
		/**
		 * Removes contenteditability and stops event handling.
		 * Changed by dfl to have the option of not setting contentEditable
		 */
		stopTracking: function (onlyICE) {
	
			this._isTracking = false;
			try { // dfl added try/catch for ie
				// If we are handling events setup the delegate to handle various events on `this.element`.
				if (this.element) {
					ice.dom.unbind(this.element, 'keyup.ice keydown.ice keypress.ice');
				}
		
				// dfl:reset contenteditable unless requested not to do so
				if (! onlyICE && (typeof(this.contentEditable) != "undefined")) {
					this.element.setAttribute('contentEditable', !this.contentEditable);
				}
			}
			catch (e){
				logError(e, "While trying to stop tracking");
			}

			this._updateTooltipsState();
			return this;
		},
	
		/**
		 * Initializes the `env` object with pointers to key objects of the page.
		 */
		initializeEnvironment: function () {
			this.env || (this.env = {});
			this.env.element = this.element;
			this.env.document = this.element.ownerDocument;
			this.env.window = this.env.document.defaultView || this.env.document.parentWindow || window;
			this.env.frame = this.env.window.frameElement;
			this.env.selection = this.selection = new ice.Selection(this.env);
		},
	
		/**
		 * Initializes the internal range object and sets focus to the editing element.
		 */
		initializeRange: function () {
/*			var range = this.selection.createRange();
			range.setStart(ice.dom.find(this.element, this.blockEls.join(', '))[0], 0);
			range.collapse(true);
			this.selection.addRange(range);
			if (this.env.frame) {
				this.env.frame.contentWindow.focus();
			}
			else {
				this.element.focus();
			} */
		},
	
		/**
		 * Initializes the content in the editor - cleans non-block nodes found between blocks and
		 * initializes the editor with any tracking tags found in the editing element.
		 */
		initializeEditor: function () {
			this._loadFromDom(); // refactored by dfl
			this._updateTooltipsState(); // dfl
		},
		
		/**
		 * Check whether or not this tracker is tracking changes.
		 * @return {Boolean} Is this tracker tracking?
		 */
		isTracking: function() {
			return this._isTracking;
		},
	
		/**
		 * Turn on change tracking and event handling.
		 */
		enableChangeTracking: function () {
			this._isTracking = true;
		},
	
		/**
		 * Turn off change tracking and event handling.
		 */
		disableChangeTracking: function () {
			this._isTracking = false;
		},
	
		/**
		 * Sets or toggles the tracking and event handling state.
		 * @param {Boolean} bTrack if undefined, the tracking state is toggled, otherwise set to the parameter
		 */
		toggleChangeTracking: function (bTrack) {
			bTrack = (undefined === bTrack) ? ! this._isTracking : !!bTrack;
			this._isTracking = bTrack;
		},
		/**
		 * Set the user to be tracked. A user object has the following properties:
		 * {`id`, `name`}
		 */
		setCurrentUser: function (user) {
			this.currentUser = user;
			this._updateUserData(user); // dfl, update data dependant on the user details
		},
		
		/**
		 * Sets or toggles the tooltips state.
		 * @param {Boolean} bTooltips if undefined, the tracking state is toggled, otherwise set to the parameter
		 */
		toggleTooltips: function(bTooltips) {
			bTooltips = (undefined === bTooltips) ? ! this.tooltips : !!bTooltips;
			this.tooltips = bTooltips;
			this._updateTooltipsState();
		},
	
		visible: function(el) {
			if(el.nodeType === ice.dom.TEXT_NODE) el = el.parentNode;
			var rect = el.getBoundingClientRect();
			return ( rect.top > 0 && rect.left > 0);
		},

	 	
		/**
		 * Returns a tracking tag for the given `changeType`, with the optional `childNode` appended.
		 * @private
		 */
		_createIceNode: function (changeType, childNode) {
			var node = this.env.document.createElement(this.changeTypes[changeType].tag);
			ice.dom.addClass(node, this._getIceNodeClass(changeType));
	
			if (childNode) {
				node.appendChild(childNode);
			}
			this._addChange(this.changeTypes[changeType].alias, [node]);
	
			return node;
		},
	
		/**
		 * Inserts the given string/node into the given range with tracking tags, collapsing (deleting)
		 * the range first if needed. If range is undefined, then the range from the Selection object
		 * is used. If the range is in a parent delete node, then the range is positioned after the delete.
		 * @param options may contain <strong>nodes</strong> (DOM element or array of dom elements) or <strong>text</strong> (string). 
		 * @returns {Boolean} true if the action should continue, false if the action was finished in the insert sequence
		 */
		insert: function (options) {
			this.hostMethods.beforeInsert && this.hostMethods.beforeInsert();

			var _rng = this.getCurrentRange(),
				range = this._isRangeInElement(_rng, this.element),
				hostRange = range ? null : this.hostMethods.getHostRange(),
				changeid = this._startBatchChange(),
				hadSelection = !!(range && !range.collapsed),
				ret = true;
			
			
		// If we have any nodes selected, then we want to delete them before inserting the new text.
			try {
				if (hadSelection) {
					this._deleteContents(false, range); 
				// Update the range
					range = this.getCurrentRange();
				}
				if (range || hostRange) {
					var nodes = options && options.nodes;
					if (nodes && ! jQuery.isArray(nodes)) {
						nodes = [nodes];
					}
			
					// If we are in a non-tracking/void element, move the range to the end/outside.
					this._moveRangeToValidTrackingPos(range, hostRange);
			
					ret = ! this._insertNodes(range, hostRange, {nodes: nodes, text: options && options.text});
				}
			}
			catch(e) {
				logError(e, "while trying to insert nodes");
			}
			finally {
				this._endBatchChange(changeid);
			}
			return ret;//isPropagating;
		},
	
		/**
		 * Deletes the contents in the given range or the range from the Selection object. If the range
		 * is not collapsed, then a selection delete is handled; otherwise, it deletes one character
		 * to the left or right if the right parameter is false or true, respectively.
		 * compared OK
		 * @return true if deletion was handled.
		 * @private
		 */
		_deleteContents: function (right, range) {
			var prevent = true,
				browser = this._browser;
			
			this.hostMethods.beforeDelete && this.hostMethods.beforeDelete();
			if (range) {
				this.selection.addRange(range);
			} 
			else {
				range = this.getCurrentRange();
			}
			var changeid = this._startBatchChange();
			try {
				if (range.collapsed === false) {
					range = this._deleteSelection(range);
	/*				if(this._browser.mozilla){
						if(range.startContainer.parentNode.previousSibling){
							range.setEnd(range.startContainer.parentNode.previousSibling, 0);
							range.moveEnd(ice.dom.CHARACTER_UNIT, ice.dom.getNodeCharacterLength(range.endContainer));
						}
						else { 
							range.setEndAfter(range.startContainer.parentNode);
						}
						range.collapse(false);
					}
					else { */
						if(range && ! this.visible(range.endContainer)) {
							range.setEnd(range.endContainer, Math.max(0, range.endOffset - 1));
							range.collapse(false);
						}
//					}
				}
				else {
			        if (right) {
						// RIGHT DELETE
						if(browser["type"] === "mozilla"){
							prevent = this._deleteRight(range);
							// Handling track change show/hide
							if(!this.visible(range.endContainer)){
								if(range.endContainer.parentNode.nextSibling){
			//						range.setEnd(range.endContainer.parentNode.nextSibling, 0);
									range.setEndBefore(range.endContainer.parentNode.nextSibling);
								} else {
									range.setEndAfter(range.endContainer);
								}
								range.collapse(false);
							}
						}
						else {
							// Calibrate Cursor before deleting
							if(range.endOffset === ice.dom.getNodeCharacterLength(range.endContainer)){
								var next = range.startContainer.nextSibling;
								if (ice.dom.is(next,  '.' + this._getIceNodeClass('deleteType'))) {
									while(next){
										if (ice.dom.is(next,  '.' + this._getIceNodeClass('deleteType'))) {
											next = next.nextSibling;
											continue;
										}
										range.setStart(next, 0);
										range.collapse(true);
										break;
									}
								}
							}
			
							// Delete
							prevent = this._deleteRight(range);
			
							// Calibrate Cursor after deleting
							if(!this.visible(range.endContainer)){
								if (ice.dom.is(range.endContainer.parentNode,  '.' + this._getIceNodeClass('insertType') + ', .' + this._getIceNodeClass('deleteType'))) {
			//						range.setStart(range.endContainer.parentNode.nextSibling, 0);
									range.setStartAfter(range.endContainer.parentNode);
									range.collapse(true);
								}
							}
						}
					}
					else {
						// LEFT DELETE
						if(browser.mozilla){
							prevent = this._deleteLeft(range);
							// Handling track change show/hide
							if(!this.visible(range.startContainer)){
								if(range.startContainer.parentNode.previousSibling){
									range.setEnd(range.startContainer.parentNode.previousSibling, 0);
								} else {
									range.setEnd(range.startContainer.parentNode, 0);
								}
								range.moveEnd(ice.dom.CHARACTER_UNIT, ice.dom.getNodeCharacterLength(range.endContainer));
								range.collapse(false);
							}
						}
						else {
							if(!this.visible(range.startContainer)){
								if(range.endOffset === ice.dom.getNodeCharacterLength(range.endContainer)){
									var prev = range.startContainer.previousSibling;
									if (ice.dom.is(prev,  '.' + this._getIceNodeClass('deleteType'))) {
										while(prev){
											if (ice.dom.is(prev,  '.' + this._getIceNodeClass('deleteType'))) {
												prev = prev.prevSibling;
												continue;
											}
											range.setEndBefore(prev.nextSibling, 0);
											range.collapse(false);
											break;
										}
									}
								}
							}
							prevent = this._deleteLeft(range);
						}
					}
				}
		
				range && this.selection.addRange(range);
			}
			finally {
				this._endBatchChange(changeid);
			}
			return prevent;
		},
	
		/**
		 * Returns the changes - a hash of objects with the following properties:
		 * [changeid] => {`type`, `time`, `userid`, `username`}
		 */
		getChanges: function () {
			return this._changes;
		},
	
		/**
		 * Returns an array with the user ids who made the changes
		 */
		getChangeUserids: function () {
			var result = [];
			var keys = Object.keys(this._changes);
	
			for (var key in keys) {
				result.push(this._changes[keys[key]].userid);
			}
	
			return result.sort().filter(function (el, i, a) {
				if (i == a.indexOf(el)) return 1;
				return 0;
			});
		},
	
		/**
		 * Returns the html contents for the tracked element.
		 */
		getElementContent: function () {
			return this.element.innerHTML;
		},
	
		/**
		 * Returns the html contents, without tracking tags, for `this.element` or
		 * the optional `body` param which can be of either type string or node.
		 * Delete tags, and their html content, are completely removed; all other
		 * change type tags are removed, leaving the html content in place. After
		 * cleaning, the optional `callback` is executed, which should further
		 * modify and return the element body.
		 *
		 * prepare gets run before the body is cleaned by ice.
		 */
		getCleanContent: function (body, callback, prepare) {
			var newBody = this.getCleanDOM(body, {callback:callback, prepare: prepare, clone: true});
			return (newBody && newBody.innerHTML) || "";
		},
		
		/**
		 * Returns a clone of the DOM, without tracking tags, for `this.element` or
		 * the optional `body` param which can be of either type string or node.
		 * Delete tags, and their html content, are completely removed; all other
		 * change type tags are removed, leaving the html content in place. 
		 * @param body If not null, the node or html to process
		 * @param options may contain:
		 * <ul><li>callback - executed after cleaning, should return the processed body
		 * <li>clone If true, process a clone of the target element
		 * <li>prepare function to run on body before the cleaning
		 */
		getCleanDOM : function(body, options) {
			var classList = '',
				self = this;
			options = options || {};
			ice.dom.each(this.changeTypes, function (type, i) {
			if (type != 'deleteType') {
				if (i > 0) classList += ',';
				classList += '.' + self._getIceNodeClass(type);
			}
			});
			if (body) {
				if (typeof body === 'string') {
					body = ice.dom.create('<div>' + body + '</div>');
				}
				else if (options.clone){
					body = ice.dom.cloneNode(body, false)[0];
				}
			} 
			else {
				body = options.clone? ice.dom.cloneNode(this.element, false)[0] : this.element;
			}
			return this._cleanBody(body, classList, options);
		},
		
		_cleanBody: function(body, classList, options) {
			body = options.prepare ? options.prepare.call(this, body) : body;
			var changes = ice.dom.find(body, classList);
			ice.dom.each(changes, function (i,el) {
				while (el.firstChild) {
					el.parentNode.insertBefore(el.firstChild, el);
				}
				el.parentNode.removeChild(el);
//				ice.dom.replaceWith(this, ice.dom.contents(this));
			});
			var deletes = ice.dom.find(body, '.' + this._getIceNodeClass('deleteType'));
			ice.dom.remove(deletes);
	
			body = options.callback ? options.callback.call(this, body) : body;
	
			return body;
		},
	
		/**
		 * Accepts all changes in the element body - removes delete nodes, and removes outer
		 * insert tags keeping the inner content in place.
		 * dfl:added support for filtering
		 */
		acceptAll: function (options) {
			if (options) {
				return this._acceptRejectSome(options, true);
			}
			else {
				this.getCleanDOM(this.element, {
					clone: false
				});
//				this.element.innerHTML = this.getCleanContent();
				this._changes = {}; // dfl, reset the changes table
				this._triggerChange(); // notify the world that our change count has changed
			}
		},
	
		/**
		 * Rejects all changes in the element body - removes insert nodes, and removes outer
		 * delete tags keeping the inner content in place.*
		 * dfl:added support for filtering
		 */
		rejectAll: function (options) {
			if (options) {
				return this._acceptRejectSome(options, false);
			}
			else {
				var insSel = '.' + this._getIceNodeClass('insertType'),
					delSel = '.' + this._getIceNodeClass('deleteType'),
					content, self = this;
		
				ice.dom.find(this.element, insSel).each(function(i,e) {
					self._removeNode(e);
				});
				ice.dom.each(ice.dom.find(this.element, delSel), function (i, el) {
					content = ice.dom.contents(el);
					ice.dom.replaceWith(el, content);
					jQuery.each(content, function(i,e) {
						var parent = e && e.parentNode;
						ice.dom.normalizeNode(parent);
					});
				});
				this._changes = {}; // dfl, reset the changes table
				this._triggerChange(); // notify the world that our change count has changed
			}
		},
	
		/**
		 * Accepts the change at the given, or first tracking parent node of, `node`.	If
		 * `node` is undefined then the startContainer of the current collapsed range will be used.
		 * In the case of insert, inner content will be used to replace the containing tag; and in
		 * the case of delete, the node will be removed.
		 */
		acceptChange: function (node) {
			this.acceptRejectChange(node, true);
		},
	
		/**
		 * Rejects the change at the given, or first tracking parent node of, `node`.	If
		 * `node` is undefined then the startContainer of the current collapsed range will be used.
		 * In the case of delete, inner content will be used to replace the containing tag; and in
		 * the case of insert, the node will be removed.
		 */
		rejectChange: function (node) {
			this.acceptRejectChange(node, false);
		},
	
		/**
		 * Handles accepting or rejecting tracking changes
		 */
		acceptRejectChange: function (node, isAccept) {
			var delSel, insSel, selector, removeSel, replaceSel, 
				trackNode, changes, dom = ice.dom, nChanges,
				self = this, changeId;
		
			if (!node) {
				var range = this.getCurrentRange();
				if (!range.collapsed) {
					return;
				}
				node = range.startContainer;
			}
		
			delSel = removeSel = '.' + this._getIceNodeClass('deleteType');
			insSel = replaceSel = '.' + this._getIceNodeClass('insertType');
			if (!isAccept) {
				removeSel = insSel;
				replaceSel = delSel;
			}
	
			selector = delSel + ',' + insSel;
			trackNode = dom.getNode(node, selector);
			changeId = dom.attr(trackNode, this.attributes.changeId); //dfl
				// Some changes are done in batches so there may be other tracking
				// nodes with the same `changeIdAttribute` batch number.
			changes = dom.find(this.element, removeSel + '[' + this.attributes.changeId + '=' + changeId + ']');
			nChanges = changes.length;
			changes.each(function(i, changeNode) {
				self._removeNode(changeNode);
			});
			dom.remove(changes);
			// we handle the replaced nodes after the deleted nodes because, well, the engine may b buggy, resulting in some nesting
			changes = dom.find(this.element, replaceSel + '[' + this.attributes.changeId + '=' + changeId + ']');
			nChanges += changes.length;
		
			dom.each(changes, function (i, node) {
				content = ice.dom.contents(node); 
				dom.replaceWith(node, content);
				jQuery.each(content, function(i,e) {
					var txt = ice.dom.TEXT_NODE == e.nodeType && e.nodeValue;
					if (txt) {
						var found = false;
						while (txt.indexOf("  ") >= 0) {
							found = true;
							txt = txt.replace("  ", " \u00a0"); // replace two spaces with space+nbsp
						}
						if (found) {
							e.nodeValue = txt;
						}
					}
					var parent = e && e.parentNode;
					ice.dom.normalizeNode(parent);
				});
			});

			/* begin dfl: if changes were accepted/rejected, remove change trigger change event */
			delete this._changes[changeId];
			if (nChanges > 0) {
				this._triggerChange();
			}
			/* end dfl */
		},
	
		/**
		 * Returns true if the given `node`, or the current collapsed range is in a tracking
		 * node; otherwise, false.
		 */
		isInsideChange: function (node) {
			try {
				return !! this.currentChangeNode(node); // refactored by dfl
			}
			catch (e) {
				logError(e, "While testing if isInsideChange");
				return false;
			}
		},
	
		/**
		 * Returns this `node` or the first parent tracking node with the given `changeType`.
		 * @private
		 */
		_getIceNode: function (node, changeType) {
			var selector = '.' + this._getIceNodeClass(changeType);
			return ice.dom.getNode((node && node.$) || node, selector);
		},
	
		/**
		 * Sets the given `range` to the first position, to the right, where it is outside of
		 * void elements.
		 * @private
		 */
		_moveRangeToValidTrackingPos: function (range, hostRange) {
			// set range to hostRange if available
			if (! (range = (hostRange || range))) {
				return;
			}
			
			var voidEl,
				el, searchBack = -1, elNode,
				visited = [], newEdge, edgeNode,
				fnode = hostRange ? this.hostMethods.getHostNode : nativeElement,
				found = false;
			while (! found) {
				el = range.startContainer;
				if (! el || visited.indexOf(el) >= 0) {
					return; // loop
				}
				elNode = fnode(el);
				visited.push(el);
				voidEl = this._getVoidElement(elNode);
				if (voidEl) {
					if ((voidEl != el) && (visited.indexOf(voidEl) >= 0)) {
						return; // loop
					}
					visited.push(voidEl);
				}
				else {
					found = ice.dom.isTextContainer(elNode);
				}
				if (! found) { // in void element or non text container
					if (-1 == searchBack) {
						searchBack = ! isOnRightEdge(fnode(range.startContainer), range.startOffset);
					}
					newEdge = searchBack ? ice.dom.findPrevTextContainer(voidEl || elNode, this.element) :
							ice.dom.findNextTextContainer(voidEl || elNode, this.element);
					edgeNode = newEdge.node;
					// we have a new edge node

					if (hostRange) {
						edgeNode = this.hostMethods.makeHostElement(edgeNode);
					}
					try { 
						if (searchBack) {
							range.setStart(edgeNode, newEdge.offset);
						}
						else {
							range.setEnd(edgeNode, newEdge.offset);
						}
						range.collapse(searchBack);
					}
					catch (e) { // if we can't set the selection for whatever reason, end of document etc., break
						logError(e, "While trying to move range to valid tracking position");
						break;
					}
				}
			}
		},
		
		/**
		 * Utility function
		 * Returns the range if its startcontainer is a descendant of (or equal to) the given top element
		 */
		_isRangeInElement: function(range, top) {
			var start = range && range.startContainer;
			while (start) {
				if (start == top) {
					return range;
				}
				start = start.parentNode;
			}
			return null;
		},
	
		/**
		 * Returns the given `node` or the first parent node that matches against the list of no track elements.
		 * @private
		 */
		_getNoTrackElement: function (node) {
			var noTrackSelector = this._getNoTrackSelector();
			var parent = ice.dom.is(node, noTrackSelector) ? node : (ice.dom.parents(node, noTrackSelector)[0] || null);
			return parent;
		},
	
		/**
		 * Returns a selector for not tracking changes
		 * @private
		 */
		_getNoTrackSelector: function () {
			return this.noTrack;
		},
	
		/**
		 * Returns the given `node` or the first parent node that matches against the list of void elements.
		 * dfl: added try/catch
		 * @private
		 */
		_getVoidElement: function (node) {
			
			try {
				var voidSelector = this._getVoidElSelector(),
					voidParent = ice.dom.is(node, voidSelector) ? node : (ice.dom.parents(node, voidSelector)[0] || null);
				if (! voidParent) {
					if (3 == node.nodeType && node.nodeValue == '\u200B') {
						return node;
					}
				}
				return voidParent;
			}
			catch(e) {
				logError(e, "While trying to get void element of", node);
				return null;
			}
		},
		
		/**
		 * @private
		 * Return true if the parameter is a text node that contains nothing or a filler char 
		 */
		_isEmptyTextNode: function(node) {
			if (! node || (ice.dom.TEXT_NODE !== node.nodeType)) {
				return false;
			}
			var nv = node.nodeValue;
			return "" === nv || '\u200B' === nv || '\uFEFF' === nv; 
		},

		/**
		 * @private
		 * If the range is collapsed, removes empty nodes around the caret
		 */
		_cleanupSelection: function(range, isHostRange) {
			var start;
			if (! range || ! range.collapsed || ! (start = range.startContainer)) {
				return;
			}
			if (isHostRange) {
				start = this.hostMethods.getHostNode(start);
			}
			var nt = start.nodeType;
			if (ice.dom.TEXT_NODE == nt) {
				return this._cleanupTextSelection(range, start, isHostRange);
			}
			else {
				return this._cleanupElementSelection(range, isHostRange);
			}
		},
		
		/**
		 * @private
		 * assumes range is valid for this operation
		 */
		_cleanupTextSelection: function(range, start, isHostRange) {
			this._cleanupAroundNode(start);
			if (this._isEmptyTextNode(start)) {
				var parent = start.parentNode, 
					ind = ice.dom.getNodeIndex(start),
					f = isHostRange ? this.hostMethods.makeHostElement : nativeElement;
				parent.removeChild(start);
				ind = Math.max(0, ind - 1);
				range.setStart(f(parent), ind);
				range.setEnd(f(parent), ind);
			}
		},

			
			/**
		 * @private
		 * assumes range is valid for this operation
		 */
		_cleanupElementSelection: function(range, isHostRange) {
			var start, includeStart = false,
				parent = isHostRange ? this.hostMethods.getHostNode(range.startContainer) : range.startContainer,
				childCount = parent.childNodes.length;
			if (childCount < 1) {
				return;
			}
			try {
				if (range.startOffset > 0) {
					start = parent.childNodes[range.startOffset - 1];
				}
				else {
					start = parent.firstChild;
					includeStart = true;
				}
				if (! start) {
					return;
				}
			}
			catch(e) {
				return;
			}
			this._cleanupAroundNode(start, includeStart);
			if (range.startOffset === 0) {
				return;
			}
			var ind = ice.dom.getNodeIndex(start) + 1;
			if (this._isEmptyTextNode(start)) {
				ind = Math.max(0, ind - 1);
				parent.removeChild(start);
			}
			if (parent.childNodes.length != childCount) {
				var f = isHostRange ? this.hostMethods.makeHostElement : nativeElement;
				range.setStart(f(parent), ind);
				range.setEnd(f(parent), ind);
			}
		},
		
		_cleanupAroundNode: function(node, includeNode) {
			var parent = node.parentNode,
				anchor = node.nextSibling,
				tmp;
			childCount = parent.childNodes.length;
			while (anchor) {
				if (this._isEmptyTextNode(anchor)) {
					tmp = anchor;
					anchor = anchor.nextSibling;
					parent.removeChild(tmp);
				}
				else {
					anchor = anchor.nextSibling;
				}
			}
			anchor = node.previousSibling;
			while (anchor) {
				if (this._isEmptyTextNode(anchor)) {
					tmp = anchor;
					anchor = anchor.previousSibling;
					parent.removeChild(tmp);
				}
				else {
					anchor = anchor.previousSibling;
				}
			}
			if (includeNode && this._isEmptyTextNode(node)) {
				parent.removeChild(node);
			}
		},
	
		/**
		 * Returns a css selector for delete .
		 * @private
		 */
		_getVoidElSelector: function () {
			return '.' + this._getIceNodeClass('deleteType');
		},
	
		/**
		 * Returns true if node has a user id attribute that matches the current user id.
		 * @private
		 */
		_currentUserIceNode: function (node) {
			return node && (ice.dom.attr(node, this.attributes.userId) == this.currentUser.id);
		},
	
		/**
		 * With the given alias, searches the changeTypes objects and returns the
		 * associated key for the alias.
		 * @private
		 */
		_getChangeTypeFromAlias: function (alias) {
			var type, ctnType = null;
			for (type in this.changeTypes) {
				if (this.changeTypes.hasOwnProperty(type)) {
					if (this.changeTypes[type].alias == alias) {
						ctnType = type;
					}
				}
			}
	
			return ctnType;
		},
	
/**
 * @private
 */				
		_getIceNodeClass: function (changeType) {
			return this.attrValuePrefix + this.changeTypes[changeType].alias;
		},
	
		/**
		 * @private
		 */				
		_getUserStyle: function (userid) {
			if (userid === null || userid === "" || "undefined" == typeof userid) {
				return this.stylePrefix;
			};
			var styleIndex = null;
			if (this._userStyles[userid]) {
				styleIndex = this._userStyles[userid];
			}
			else {
				styleIndex = this._setUserStyle(userid, this._getNewStyleId());
			}
			return styleIndex;
		},
	
		/**
		 * @private
		 */
		_setUserStyle: function (userid, styleIndex) {
			var style = this.stylePrefix + '-' + styleIndex;
			if (!this._styles[styleIndex]) {
				this._styles[styleIndex] = true;
			}
			return this._userStyles[userid] = style;
		},
	
		_getNewStyleId: function () {
			var id = ++this._uniqueStyleIndex;
			if (this._styles[id]) {
			// Dupe.. create another..
				return this._getNewStyleId();
			} 
			else {
				this._styles[id] = true;
				return id;
			}
		},
	
		_addChange: function (ctnType, ctNodes) {
			var changeid = this._batchChangeId || this.getNewChangeId(),
				self = this;

			if (!this._changes[changeid]) {
				// Create the change object.
				this._changes[changeid] = {
					type: this._getChangeTypeFromAlias(ctnType),
					time: (new Date()).getTime(),
					userid: String(this.currentUser.id),// dfl: must stringify for consistency - when we read the props from dom attrs they are strings
					username: this.currentUser.name,
					data : this._changeData || ""
				};
				this._triggerChange(); //dfl
			}
			ice.dom.foreach(ctNodes, function (i) {
				self._addNodeToChange(changeid, ctNodes[i]);
			});
	
			return changeid;
		},
	
		/**
		 * Adds tracking attributes from the change with changeid to the ctNode.
		 * @param changeid Id of an existing change.
		 * @param ctNode The element to add for the change.
		 * @private
		 */
		_addNodeToChange: function (changeid, ctNode) {
			changeid = this._batchChangeId || changeid;
			var change = this.getChange(changeid);
			
			if (!ctNode.getAttribute(this.attributes.changeId)) {
				ctNode.setAttribute(this.attributes.changeId, changeid);
			}
// modified by dfl, handle missing userid, try to set username according to userid
			var userId = ctNode.getAttribute(this.attributes.userId); 
			if (! userId) {
				ctNode.setAttribute(this.attributes.userId, userId = change.userid);
			}
			if (userId == change.userid) {
				ctNode.setAttribute(this.attributes.userName, change.username);
			}
			
// dfl add change data
			var changeData = ctNode.getAttribute(this.attributes.changeData);
			if (null == changeData) {
				ctNode.setAttribute(this.attributes.changeData, this._changeData || "");
			}
			
			if (!ctNode.getAttribute(this.attributes.time)) {
				ctNode.setAttribute(this.attributes.time, change.time);
			}
			
//			if (!ice.dom.hasClass(ctNode, this._getIceNodeClass(change.type))) ice.dom.addClass(ctNode, this._getIceNodeClass(change.type));
	
			var style = this._getUserStyle(change.userid);
			if (!ice.dom.hasClass(ctNode, style)) {
				ice.dom.addClass(ctNode, style);
			}
			/* Added by dfl */
			this._updateNodeTooltip(ctNode);
		},
	
		getChange: function (changeid) {
			return this._changes[changeid] || null;
		},
	
		getNewChangeId: function () {
			var id = ++this._uniqueIDIndex;
			if (this._changes[id]) {
			// Dupe.. create another..
			id = this.getNewChangeId();
			}
			return id;
		},
	
		/**
		 * @private
		 * Start a batch change if none is already underway
		 * @return a change id if a new batch has been started, otherwise null
		 */
		_startBatchChange: function () {
			return this._batchChangeId ? null : 
				(this._batchChangeId = this.getNewChangeId());
		},
		
		/**
		 * Returns the top level DOM element handled by this change tracker
		 */
		getContentElement: function() {
			return this.element;
		},
		
		/**
		 * @private
		 * End the batch change
		 * @param changeid If not identical to the current change id, no action is taken
		 * this allows callers to start a batch change but end it only if the change was really started by the caller
		 */
		_endBatchChange: function (changeid) {
			if (changeid && (changeid === this._batchChangeId)) {
				this._batchChangeId = null;
				this._triggerChangeText();
			}
		},
	
		getCurrentRange: function () {
			try {
				return this.selection.getRangeAt(0);
			}
			catch (e) {
				logError(e, "While trying to get current range");
				return null;
			}
		},
	
		_insertNodes: function (_range, hostRange, data) {
			var range = hostRange || _range,
				_start = range.startContainer,
				start = (_start && _start.$) || _start,
				f = hostRange ? this.hostMethods.makeHostElement : nativeElement,
				nodes = data && data.nodes,
				text = data && data.text,
				doc= this.env.document,
				inserted = false;
			
			var ctNode = this._getIceNode(start, 'insertType'),
				inCurrentUserInsert = this._currentUserIceNode(ctNode);
	
			if (inCurrentUserInsert) {
				var head = nodes && nodes[0];
				if (head) {
					inserted = true;
					range.insertNode(f(head));
					var parent = head.parentNode,
						sibling = head.nextSibling,
						len = nodes.length;
					for (var i = 1; i < len; ++i) {
						if (sibling) {
							parent.insertBefore(nodes[i], sibling);
						}
						else {
							parent.appendChild(nodes[i]);
						}
					}
					/* Now move the caret to the end of the last node inserted */
					var tail = nodes[len - 1];
					if (ice.dom.TEXT_NODE == tail.nodeType) {
						range.setEnd(tail, (tail.nodeValue && tail.nodeValue.length) || 0);
					}
					else {
						range.setEndAfter(tail);
					}
					range.collapse();
					if (hostRange) {
						this.hostMethods.setHostRange(hostRange);
					}
					else {
						this.selection.addRange(range);
					}
				}
			}
			else {
				// If we aren't in an insert node which belongs to the current user, then create a new ins node
				var node = this._createIceNode('insertType');
				if (ctNode) {
					var nChildren = ctNode.childNodes.length;
					ice.dom.normalizeNode(ctNode);
					if (nChildren != ctNode.childNodes.length) { // normalization removed nodes, refresh range
						if (hostRange) {
							hostRange = range = this.hostMethods.getHostRange();
						}
						else {
							range.refresh();
						}
					}
					if (ctNode) {
						var end = (hostRange && this.hostMethods.getHostNode(hostRange.endContainer)) || range.endContainer;
						// if inserting before the end of a tracked node by another user
						if ((end.nodeType == 3 && range.endOffset < range.endContainer.length) || (end != ctNode.lastChild)) {
							ctNode = this._splitNode(ctNode, range.endContainer, range.endOffset);
						}
					}
				}
				if (ctNode) {
					range.setStartAfter(f(ctNode));
					range.collapse(true);
				}

				
				this._cleanupSelection(range, !! hostRange);
				range.insertNode(f(node));
				var len = (nodes && nodes.length) || 0;
				if (len) {
					inserted = true;
					for (var i = 0; i < len; ++i) {
						node.appendChild(nodes[i]);
					}
					range.setEndAfter(f(node.lastChild));
					range.collapse();
				}
				else if (text) {
					inserted = true;
					var tn = doc.createTextNode(text);
					node.appendChild(tn);
					range.setEnd(tn, 1);
					range.collapse();
				}
				else {
					var tn = doc.createTextNode('\uFEFF');
					node.appendChild(tn);
					tn = f(tn);
					range.setStart(tn, 0);
					range.setEnd(tn, 1);
				}
				if (hostRange) {
					this.hostMethods.setHostRange(hostRange);
				}
				else {
					this.selection.addRange(range);
				}
			}
			return inserted;
		},
	
// compared OK
		_handleVoidEl: function(el, range) {
			// If `el` is or is in a void element, but not a delete
			// then collapse the `range` and return `true`.
			var voidEl = el && this._getVoidElement(el);
			if (voidEl && !this._getIceNode(voidEl, 'deleteType')) {
				range.collapse(true);
				return true;
			}
			return false;
		},
	
// compared OK
		_deleteSelection: function (range) {
	
			// Bookmark the range and get elements between.
			var bookmark = new ice.Bookmark(this.env, range),
				elements = ice.dom.getElementsBetween(bookmark.start, bookmark.end),
				b1 = ice.dom.parents(range.startContainer, this.blockEls.join(', '))[0],
				b2 = ice.dom.parents(range.endContainer, this.blockEls.join(', '))[0],
				betweenBlocks = new Array(); 
	// elements length may change during the loop so don't optimize
			for (var i = 0; i < elements.length; i++) {
				var elem = elements[i];
				if (! elem || ! elem.parentNode) { // maybe removed as a side effect of removing other stuff
					continue;
				}
				if (ice.dom.isBlockElement(elem)) {
					betweenBlocks.push(elem);
					if (!ice.dom.canContainTextElement(elem)) {
						// Ignore containers that are not supposed to contain text. Check children instead.
						for (var k = 0; k < elem.childNodes.length; k++) {
							elements.push(elem.childNodes[k]);
						}
						continue;
					}
				}
				// Ignore empty space nodes
				if (elem.nodeType === ice.dom.TEXT_NODE && ice.dom.getNodeTextContent(elem).length === 0) {
					continue;
				}
		
				if (!this._getVoidElement(elem)) {
					// If the element is not a text or stub node, go deeper and check the children.
					if (elem.nodeType !== ice.dom.TEXT_NODE) {
						// Browsers like to insert breaks into empty paragraphs - remove them
						if (ice.dom.BREAK_ELEMENT == ice.dom.getTagName(elem)) {
							continue;
						}
			
						if (ice.dom.isStubElement(elem)) {
							this._addDeleteTracking(elem, {range:null, moveLeft:true});
							continue;
						}
						if (ice.dom.hasNoTextOrStubContent(elem)) {
							this._removeNode(elem);
							continue;
						}
			
						for (var j = 0; j < elem.childNodes.length; j++) {
							var child = elem.childNodes[j];
							elements.push(child);
						}
						continue;
					}
					var parentBlock = ice.dom.getBlockParent(elem);
					this._addDeleteTracking(elem, {range:null, moveLeft:true});
					if (ice.dom.hasNoTextOrStubContent(parentBlock)) {
						ice.dom.remove(parentBlock);
					}
				}
			}
	
			if (this.mergeBlocks && b1 !== b2) {
				while (betweenBlocks.length) {
					ice.dom.mergeContainers(betweenBlocks.shift(), b1);
				}
//				ice.dom.removeBRFromChild(b2);
//				ice.dom.removeBRFromChild(b1);
				ice.dom.mergeContainers(b2, b1);
			}
	
			bookmark.selectBookmark();
			if (range = this.getCurrentRange()) {
				range.collapse(true);
			}
			return range;
		},
	
		/**
		 * Deletes to the right (delete key)
		 * @private
		 */
		_deleteRight: function (range) {
	
			var parentBlock = ice.dom.isBlockElement(range.startContainer) && range.startContainer || ice.dom.getBlockParent(range.startContainer, this.element) || null,
				isEmptyBlock = parentBlock ? (ice.dom.hasNoTextOrStubContent(parentBlock)) : false,
				nextBlock = parentBlock && ice.dom.getNextContentNode(parentBlock, this.element),
				nextBlockIsEmpty = nextBlock ? (ice.dom.hasNoTextOrStubContent(nextBlock)) : false,
				initialContainer = range.endContainer,
				initialOffset = range.endOffset,
				commonAncestor = range.commonAncestorContainer,
				nextContainer, returnValue;
	
	
			// If the current block is empty then let the browser handle the delete/event.
			if (isEmptyBlock) {
				return false;
			}
	
			// Some bugs in Firefox and Webkit make the caret disappear out of text nodes, so we try to put them back in.
			if (commonAncestor.nodeType !== ice.dom.TEXT_NODE) {
	
				// If placed at the beginning of a container that cannot contain text, such as an ul element, place the caret at the beginning of the first item.
				if (initialOffset === 0 && ice.dom.isBlockElement(commonAncestor) && (!ice.dom.canContainTextElement(commonAncestor))) {
					var firstItem = commonAncestor.firstElementChild;
					if (firstItem) {
						range.setStart(firstItem, 0);
						range.collapse();
						return this._deleteRight(range);
					}
				}
		
				if (commonAncestor.childNodes.length > initialOffset) {
					var tempTextContainer = document.createTextNode(' ');
					commonAncestor.insertBefore(tempTextContainer, commonAncestor.childNodes[initialOffset]);
					range.setStart(tempTextContainer, 1);
					range.collapse(true);
					returnValue = this._deleteRight(range);
					var tParent = tempTextContainer.parentNode;
					this._removeNode(tempTextContainer);
					range.refresh();
					return returnValue;
				} 
				else {
					nextContainer = ice.dom.getNextContentNode(commonAncestor, this.element);
					range.setEnd(nextContainer, 0);
					range.collapse();
					return this._deleteRight(range);
				}
			}
	
			// Move range to position the cursor on the inside of any adjacent container that it is going
			// to potentially delete into or after a stub element.	E.G.:	test|<em>text</em>	->	test<em>|text</em> or
			// text1 |<img> text2 -> text1 <img>| text2

			range.moveEnd(ice.dom.CHARACTER_UNIT, 1);
			range.moveEnd(ice.dom.CHARACTER_UNIT, -1);
	
			// Handle cases of the caret is at the end of a container or placed directly in a block element
			if (initialOffset === initialContainer.data.length && (!ice.dom.hasNoTextOrStubContent(initialContainer))) {
				nextContainer = ice.dom.getNextNode(initialContainer, this.element);
		
				// If the next container is outside of ICE then do nothing.
				if (!nextContainer) {
					range.selectNodeContents(initialContainer);
					range.collapse();
					return false;
				}
		
				// If the next container is <br> element find the next node
				if (ice.dom.BREAK_ELEMENT == ice.dom.getTagName(nextContainer)) {
					nextContainer = ice.dom.getNextNode(nextContainer, this.element);
				}
		
				// If the next container is a text node, look at the parent node instead.
				if (nextContainer.nodeType === ice.dom.TEXT_NODE) {
					nextContainer = nextContainer.parentNode;
				}
		
				// If the next container is non-editable, enclose it with a delete ice node and add an empty text node after it to position the caret.
				if (!nextContainer.isContentEditable) {
					returnValue = this._addDeleteTracking(nextContainer, {range:null, moveLeft:false, merge: true});
					var emptySpaceNode = this.env.document.createTextNode('');
					nextContainer.parentNode.insertBefore(emptySpaceNode, nextContainer.nextSibling);
					range.selectNode(emptySpaceNode);
					range.collapse(true);
					return returnValue;
				}
		
				if (this._handleVoidEl(nextContainer, range)) {
					return true;
				}
		
				// If the caret was placed directly before a stub element, enclose the element with a delete ice node.
				if (ice.dom.isChildOf(nextContainer, parentBlock) && ice.dom.isStubElement(nextContainer)) {
					return this._addDeleteTracking(nextContainer, {range:range, moveLeft:false, merge:true});
				}
	
			}
	
			if (this._handleVoidEl(nextContainer, range)) {
				return true;
			}
	
			// If we are deleting into a no tracking containiner, then remove the content
			if (this._getNoTrackElement(range.endContainer.parentElement)) {
				range.deleteContents();
				return false;
			}
	
			if (ice.dom.isOnBlockBoundary(range.startContainer, range.endContainer, this.element)) {
				if (this.mergeBlocks && ice.dom.is(ice.dom.getBlockParent(nextContainer, this.element), this.blockEl)) {
					// Since the range is moved by character, it may have passed through empty blocks.
					// <p>text {RANGE.START}</p><p></p><p>{RANGE.END} text</p>
					if (nextBlock !== ice.dom.getBlockParent(range.endContainer, this.element)) {
						range.setEnd(nextBlock, 0);
					}
					// The browsers like to auto-insert breaks into empty paragraphs - remove them.
					var elements = ice.dom.getElementsBetween(range.startContainer, range.endContainer);
					for (var i = 0; i < elements.length; i++) {
						ice.dom.remove(elements[i]);
					}
					var startContainer = range.startContainer,
						endContainer = range.endContainer;
					ice.dom.remove(ice.dom.find(startContainer, 'br'));
					ice.dom.remove(ice.dom.find(endContainer, 'br'));
					return ice.dom.mergeBlockWithSibling(range, ice.dom.getBlockParent(range.endContainer, this.element) || parentBlock);
				} else {
					// If the next block is empty, remove the next block.
					if (nextBlockIsEmpty) {
						ice.dom.remove(nextBlock);
						range.collapse(true);
						return true;
					}
		
					// Place the caret at the start of the next block.
					range.setStart(nextBlock, 0);
					range.collapse(true);
					return true;
				}
			}
	
			var entireTextNode = range.endContainer,
				deletedCharacter = entireTextNode.splitText(range.endOffset),
				remainingTextNode = deletedCharacter.splitText(1);
	
			return this._addDeleteTracking(deletedCharacter, {range:range, moveLeft:false, merge:true});
	
		},
	
		/**
		 * Deletes to the left (backspace)
		 * @private
		 */
		_deleteLeft: function (range) {
	
			var parentBlock = ice.dom.isBlockElement(range.startContainer) && range.startContainer || ice.dom.getBlockParent(range.startContainer, this.element) || null,
			isEmptyBlock = parentBlock ? ice.dom.hasNoTextOrStubContent(parentBlock) : false,
			prevBlock = parentBlock && ice.dom.getPrevContentNode(parentBlock, this.element), // || ice.dom.getBlockParent(parentBlock, this.element) || null,
			prevBlockIsEmpty = prevBlock ? ice.dom.hasNoTextOrStubContent(prevBlock) : false,
			initialContainer = range.startContainer,
			initialOffset = range.startOffset,
			commonAncestor = range.commonAncestorContainer,
			lastSelectable, prevContainer;
	
			// If the current block is empty, then let the browser handle the key/event.
			if (isEmptyBlock) {
				return false;
			}
	
			// Handle cases of the caret is at the start of a container or outside a text node
			if (initialOffset === 0 || commonAncestor.nodeType !== ice.dom.TEXT_NODE) {
			// If placed at the end of a container that cannot contain text, such as an ul element, place the caret at the end of the last item.
				if (ice.dom.isBlockElement(commonAncestor) && (!ice.dom.canContainTextElement(commonAncestor))) {
					if (initialOffset === 0) {
						var firstItem = commonAncestor.firstElementChild;
						if (firstItem) {
							range.setStart(firstItem, 0);
							range.collapse();
							return this._deleteLeft(range);
						}
					} 
					else {
						var lastItem = commonAncestor.lastElementChild;
						if (lastItem) {
							lastSelectable = range.getLastSelectableChild(lastItem);
							if (lastSelectable) {
								range.setStart(lastSelectable, lastSelectable.data.length);
								range.collapse();
								return this._deleteLeft(range);
							}
						}
					}
				}
		
				if (initialOffset === 0) {
					prevContainer = ice.dom.getPrevContentNode(initialContainer, this.element);
				} 
				else {
					prevContainer = commonAncestor.childNodes[initialOffset - 1];
				}
		
				// If the previous container is outside of ICE then do nothing.
				if (!prevContainer) {
					return false;
				}
		
				// Firefox finds an ice node wrapped around an image instead of the image itself sometimes, so we make sure to look at the image instead.
				if (ice.dom.is(prevContainer,	'.' + this._getIceNodeClass('insertType') + ', .' + this._getIceNodeClass('deleteType')) && prevContainer.childNodes.length > 0 && prevContainer.lastChild) {
					prevContainer = prevContainer.lastChild;
				}
		
				// If the previous container is a text node, look at the parent node instead.
				if (prevContainer.nodeType === ice.dom.TEXT_NODE) {
					prevContainer = prevContainer.parentNode;
				}
		
				// If the previous container is non-editable, enclose it with a delete ice node and add an empty text node before it to position the caret.
				if (!prevContainer.isContentEditable) {
					var returnValue = this._addDeleteTracking(prevContainer, {range:null, moveLeft:true, merge:true});
					var emptySpaceNode = document.createTextNode('');
					prevContainer.parentNode.insertBefore(emptySpaceNode, prevContainer);
					range.selectNode(emptySpaceNode);
					range.collapse(true);
					return returnValue;
				}
		
				if (this._handleVoidEl(prevContainer, range)) {
					return true;
				}
		
				// If the caret was placed directly after a stub element, enclose the element with a delete ice node.
				if (ice.dom.isStubElement(prevContainer) && ice.dom.isChildOf(prevContainer, parentBlock) || !prevContainer.isContentEditable) {
					 return this._addDeleteTracking(prevContainer, {range:range, moveLeft:true, merge:true});
				}
		
				// If the previous container is a stub element between blocks
				// then just delete and leave the range/cursor in place.
				if (ice.dom.isStubElement(prevContainer)) {
					ice.dom.remove(prevContainer);
					range.collapse(true);
					return false;
				}
		
				if (prevContainer !== parentBlock && !ice.dom.isChildOf(prevContainer, parentBlock)) {
		
					if (!ice.dom.canContainTextElement(prevContainer)) {
						prevContainer = prevContainer.lastElementChild;
					}
					// Before putting the caret into the last selectable child, lets see if the last element is a stub element. If it is, we need to put the caret there manually.
					if (prevContainer.lastChild && prevContainer.lastChild.nodeType !== ice.dom.TEXT_NODE && ice.dom.isStubElement(prevContainer.lastChild) && prevContainer.lastChild.tagName !== 'BR') {
						range.setStartAfter(prevContainer.lastChild);
						range.collapse(true);
						return true;
					}
					// Find the last selectable part of the prevContainer. If it exists, put the caret there.
					lastSelectable = range.getLastSelectableChild(prevContainer);
		
					if (lastSelectable && !ice.dom.isOnBlockBoundary(range.startContainer, lastSelectable, this.element)) {
						range.selectNodeContents(lastSelectable);
						range.collapse();
						return true;
					}
				}
			}
	
			// Firefox: If an image is at the start of the paragraph and the user has just deleted the image using backspace, an empty text node is created in the delete node before
			// the image, but the caret is placed with the image. We move the caret to the empty text node and execute deleteFromLeft again.
			if (initialOffset === 1 && !ice.dom.isBlockElement(commonAncestor) && range.startContainer.childNodes.length > 1 && range.startContainer.childNodes[0].nodeType === ice.dom.TEXT_NODE && range.startContainer.childNodes[0].data.length === 0) {
				range.setStart(range.startContainer, 0);
				return this._deleteLeft(range);
			}
	
			// Move range to position the cursor on the inside of any adjacent container that it is going
			// to potentially delete into or before a stub element.	E.G.: <em>text</em>| test	->	<em>text|</em> test or
			// text1 <img>| text2 -> text1 |<img> text2
			range.moveStart(ice.dom.CHARACTER_UNIT, -1);
			range.moveStart(ice.dom.CHARACTER_UNIT, 1);
	
			// If we are deleting into a no tracking containiner, then remove the content
			if (this._getNoTrackElement(range.startContainer.parentElement)) {
				range.deleteContents();
				return false;
			}
	
			// Handles cases in which the caret is at the start of the block.
			if (ice.dom.isOnBlockBoundary(range.startContainer, range.endContainer, this.element)) {
		
				// If the previous block is empty, remove the previous block.
				if (prevBlockIsEmpty) {
					ice.dom.remove(prevBlock);
					range.collapse();
					return true;
				}
		
				// Merge blocks: If mergeBlocks is enabled, merge the previous and current block.
				if (this.mergeBlocks && ice.dom.is(ice.dom.getBlockParent(prevContainer, this.element), this.blockEl)) {
					// Since the range is moved by character, it may have passed through empty blocks.
					// <p>text {RANGE.START}</p><p></p><p>{RANGE.END} text</p>
					if (prevBlock !== ice.dom.getBlockParent(range.startContainer, this.element)) {
					range.setStart(prevBlock, prevBlock.childNodes.length);
					}
					// The browsers like to auto-insert breaks into empty paragraphs - remove them.
					var elements = ice.dom.getElementsBetween(range.startContainer, range.endContainer)
					for (var i = 0; i < elements.length; i++) {
						ice.dom.remove(elements[i]);
					}
					var startContainer = range.startContainer;
					var endContainer = range.endContainer;
					ice.dom.remove(ice.dom.find(startContainer, 'br'));
					ice.dom.remove(ice.dom.find(endContainer, 'br'));
					return ice.dom.mergeBlockWithSibling(range, ice.dom.getBlockParent(range.endContainer, this.element) || parentBlock);
				}
		
				// If the previous Block ends with a stub element, set the caret behind it.
				if (prevBlock && prevBlock.lastChild && ice.dom.isStubElement(prevBlock.lastChild)) {
					range.setStartAfter(prevBlock.lastChild);
					range.collapse(true);
					return true;
				}
		
				// Place the caret at the end of the previous block.
				lastSelectable = range.getLastSelectableChild(prevBlock);
				if (lastSelectable) {
					range.setStart(lastSelectable, lastSelectable.data.length);
					range.collapse(true);
				} 
				else if (prevBlock) {
					range.setStart(prevBlock, prevBlock.childNodes.length);
					range.collapse(true);
				}
		
				return true;
			}
	
			var entireTextNode = range.startContainer,
				deletedCharacter = entireTextNode.splitText(range.startOffset - 1);
				
			deletedCharacter.splitText(1);
	
			return this._addDeleteTracking(deletedCharacter, {range:range, moveLeft:true, merge:true});
	
		},
		
		_removeNode: function(node) {
			var parent = node && node.parentNode;
			if (parent) {
				parent.removeChild(node);
				if (ice.dom.hasNoTextOrStubContent(parent)) {
					this._removeNode(parent);
				}
			}
		},
	
		// Marks text and other nodes for deletion
		// compared OK
/**
 * @private
 * Adds delete tracking to the provided node. The node is checked for containment in various tracking contexts
 * (e.g. inside an insert block, delete block)
 */
		_addDeleteTracking: function (contentNode, options) {
	
			var contentAddNode = this._getIceNode(contentNode, 'insertType'),
				ctNode;
	
			if (contentAddNode) {
				return this._addDeletionInInsertNode(contentNode, contentAddNode, options);
			}
			
			var range = options && options.range;
			if (range && this._getIceNode(contentNode, 'deleteType')) {
				return this._deleteInDeleted(contentNode, options);
	
			}
			// Webkit likes to insert empty text nodes next to elements. We remove them here.
			if (contentNode.previousSibling && contentNode.previousSibling.nodeType === ice.dom.TEXT_NODE && contentNode.previousSibling.length === 0) {
				contentNode.parentNode.removeChild(contentNode.previousSibling);
			}
			if (contentNode.nextSibling && contentNode.nextSibling.nodeType === ice.dom.TEXT_NODE && contentNode.nextSibling.length === 0) {
				contentNode.parentNode.removeChild(contentNode.nextSibling);
			}
			var prevDelNode = this._getIceNode(contentNode.previousSibling, 'deleteType'),
				nextDelNode = this._getIceNode(contentNode.nextSibling, 'deleteType');
	
			if (prevDelNode && this._currentUserIceNode(prevDelNode)) {
				ctNode = prevDelNode;
				ctNode.appendChild(contentNode);
				if (nextDelNode && this._currentUserIceNode(nextDelNode)) {
					var nextDelContents = ice.dom.extractContent(nextDelNode);
					ice.dom.append(ctNode, nextDelContents);
					nextDelNode.parentNode.removeChild(nextDelNode);
				}
			} 
			else if (nextDelNode && this._currentUserIceNode(nextDelNode)) {
				ctNode = nextDelNode;
				ctNode.insertBefore(contentNode, ctNode.firstChild);
			} 
			else { // not in the neighborhood of a delete node
				ctNode = this._createIceNode('deleteType');
				contentNode.parentNode.insertBefore(ctNode, contentNode);
				ctNode.appendChild(contentNode);
			}
	
			if (range) {
				var moveLeft = options && options.moveLeft;
				if (ice.dom.isStubElement(contentNode)) {
					range.selectNode(contentNode);
				} 
				else {
					range.selectNodeContents(contentNode);
				}
				if (moveLeft) {
					range.collapse(true);
				} 
				else {
					range.collapse();
				}
				ice.dom.normalizeNode(contentNode); // dfl - support ie8
			}
			return true;
	
		},
		
		/**
		 * Handle the case of deletion inside a delete element
		 */
		_deleteInDeleted: function(contentNode, options) {
			var range = options.range, 
				moveLeft = options.moveLeft,
				ctNode;

			// It if the contentNode a text node, merge it with text nodes before and after it.
			ice.dom.normalizeNode(contentNode);// dfl - support ie8
	
			var found = false;
			if (moveLeft) {
				// Move to the left until there is valid sibling.
				var previousSibling = ice.dom.getPrevContentNode(contentNode, this.element);
				while (!found) {
					ctNode = this._getIceNode(previousSibling, 'deleteType');
					if (!ctNode) {
						found = true;
					} 
					else {
						previousSibling = ice.dom.getPrevContentNode(previousSibling, this.element);
					}
				}
				if (previousSibling) {
					var lastSelectable = range.getLastSelectableChild(previousSibling);
					if (lastSelectable) {
						previousSibling = lastSelectable;
					}
					range.setStart(previousSibling, ice.dom.getNodeCharacterLength(previousSibling));
					range.collapse(true);
				}
			} 
			else {
				// Move the range to the right until there is valid sibling.
	
				var nextSibling = ice.dom.getNextContentNode(contentNode, this.element);
				while (!found) {
					ctNode = this._getIceNode(nextSibling, 'deleteType');
					if (!ctNode) {
						found = true;
					} 
					else {
						nextSibling = ice.dom.getNextContentNode(nextSibling, this.element);
					}
				}
	
				if (nextSibling) {
					range.selectNodeContents(nextSibling);
					range.collapse(true);
				}
			}
			return true;
		},
		

/**
 * @private
 * Adds delete tracking markup around a content node
 * @param contentNode the content to be marked as deleted
 * @param contentAddNode the insert node surrounding the content
 * @options may contain range, moveLeft, merge
 */
		_addDeletionInInsertNode: function(contentNode, contentAddNode, options) {
			var range = options && options.range,
				moveLeft = options && options.moveLeft;
			if (this._currentUserIceNode(contentAddNode)) {
				if (range) {
					if (moveLeft) {
						range.setStartBefore(contentNode);
					}
					else {
						range.setStartAfter(contentNode);
					}
					range.collapse(moveLeft);
				}
				contentNode.parentNode.removeChild(contentNode);
				if (! this._browser.msie) {
					ice.dom.normalizeNode(contentAddNode);	
				}
				var bmCount = ice.dom.find(contentAddNode, ".iceBookmark").length,
					cleanNode;
				if (bmCount > 0) {
					cleanNode = ice.dom.cloneNode(contentAddNode);
					ice.dom.remove(ice.dom.find(cleanNode, '.iceBookmark'));
					cleanNode = cleanNode[0];
				}
				else {
					cleanNode = contentAddNode;
				}
					
				// Remove a potential empty tracking container
				if (ice.dom.hasNoTextOrStubContent(cleanNode)) {
//					var newstart = this.env.document.createTextNode('');
//					ice.dom.insertBefore(contentAddNode, newstart);
					if (range) {
						range.setStartBefore(contentAddNode);
						range.collapse(true);
					}
					ice.dom.replaceWith(contentAddNode, ice.dom.contents(contentAddNode));
				}
			}
			else { // other user insert
				var cInd = rangy.dom.getNodeIndex(contentNode),
					parent = contentNode.parentNode,
					nChildren = parent.childNodes.length,
					ctNode;
				parent.removeChild(contentNode);
				ctNode = this._createIceNode('deleteType');
				ctNode.appendChild(contentNode);
				if (cInd > 0 && cInd >= (nChildren - 1)) {
					contentAddNode.parentNode.appendChild(ctNode);
				}
				else {
					if (cInd > 0) {
						this._splitNode(contentAddNode, parent, cInd);
					}
					contentAddNode.parentNode.insertBefore(ctNode, contentAddNode);
				}
				this._deleteEmptyNode(contentAddNode);


				if (range && moveLeft) {
					range.setStartBefore(ctNode);
					range.collapse(true);
					this.selection.addRange(range);
				}
				if (options && options.merge) {
					this._mergeDeleteNode(ctNode);
				}
				if (range) {
					range.refresh();
				}

			}
			return true;
		},
		

		/**
		 * @private
		 * Deletes a node if it does not contain anything 
		 */
		_deleteEmptyNode: function(node) {
			var parent = node && node.parentNode;
			if (parent && ice.dom.hasNoTextOrStubContent(node)) {
				parent.removeChild(node);
			}
		},
	
		/**
		 * Merges a delete node with its siblings if they belong to the same user
		 */
		_mergeDeleteNode: function(delNode) {
			var siblingDel,
				content;
	
			if (this._currentUserIceNode(siblingDel = this._getIceNode(delNode.previousSibling, 'deleteType'))) {
				content = ice.dom.extractContent(delNode);
				delNode.parentNode.removeChild(delNode);
				ice.dom.append(siblingDel, content);
				this._mergeDeleteNode(siblingDel);
			}
			else if (this._currentUserIceNode(siblingDel = this._getIceNode(delNode.nextSibling, 'deleteType'))) {
					content = ice.dom.extractContent(siblingDel);
					delNode.parentNode.removeChild(siblingDel);
					ice.dom.append(delNode, content);
					this._mergeDeleteNode(delNode);
			} 
		},
	
	
		/**
		 * If tracking is on, handles event e when it is one of the following types:
		 * mouseup, mousedown, keypress, keydown, and keyup. Prevents default handling if the event
		 * was fully handled.
		 * @private
		 */
		_handleEvent: function (e) {
			if (!this._isTracking) {
				return true;
			}
			var needsToBubble = true;
			if ('keypress' == e.type) {
				needsToBubble = this.keyPress(e);
			} 
			else if ('keydown' == e.type) {
				needsToBubble = this.keyDown(e);
			}
			if (!needsToBubble) {
				e.preventDefault();
			}
			return needsToBubble;
		},

		/**
		 * Handles arrow, delete key events, and others.
		 *
		 * @param {JQuery Event} e The event object.
		 * return {void|boolean} Returns false if default event needs to be blocked.
		 * @private
		 */
		_handleAncillaryKey: function (e) {
			var key = e.keyCode ? e.keyCode : e.which,
	    		browser = this._browser,
				preventDefault = true,
				shiftKey = e.shiftKey,
				self = this,
				range = self.getCurrentRange();
			switch (key) {
				case ice.dom.DOM_VK_DELETE:
					preventDefault = this._deleteContents();
					break;
		
				case 46:
					// Key 46 is the DELETE key.
					preventDefault = this._deleteContents(true);
					break;
		
		/* ***********************************************************************************/
		/* BEGIN: Handling of caret movements inside hidden .ins/.del elements on Firefox **/
		/*  *Fix for carets getting stuck in .del elements when track changes are hidden  **/
				case ice.dom.DOM_VK_DOWN:
				case ice.dom.DOM_VK_UP:
				case ice.dom.DOM_VK_LEFT:
					if(browser["type"] === "mozilla"){
						if(!this.visible(range.startContainer)){
							// if Previous sibling exists in the paragraph, jump to the previous sibling
							if(range.startContainer.parentNode.previousSibling){
								// When moving left and moving into a hidden element, skip it and go to the previousSibling
								range.setEnd(range.startContainer.parentNode.previousSibling, 0);
								range.moveEnd(ice.dom.CHARACTER_UNIT, ice.dom.getNodeCharacterLength(range.endContainer));
								range.collapse(false);
							}
							// if Previous sibling doesn't exist, get out of the hidden zone by moving to the right
							else {
								range.setEnd(range.startContainer.parentNode.nextSibling, 0);
								range.collapse(false);
							}
						}
					  }	
			          preventDefault = false;
			          break;
				case ice.dom.DOM_VK_RIGHT:
					if(browser["type"] === "mozilla"){
						if(!this.visible(range.startContainer)){
							if(range.startContainer.parentNode.nextSibling){
								// When moving right and moving into a hidden element, skip it and go to the nextSibling
								range.setStart(range.startContainer.parentNode.nextSibling,0);
								range.collapse(true);
							}
						}
					}
					preventDefault = false;
					break;
		/* END: Handling of caret movements inside hidden .ins/.del elements ***************/
		/* ***********************************************************************************/
// dfl deleted space handling code
/*				case 32:
					preventDefault = true;
					var range = this.getCurrentRange();
					this._moveRangeToValidTrackingPos(range, range.startContainer);
					this.insert('\u00A0' , range);
					break; */
				default:
					// Ignore key.
					preventDefault = false;
					break;
			} //end switch
	
			if (preventDefault === true) {
				ice.dom.preventDefault(e);
				return false;
			}
			return true;
	
		},
	
		// compared OK
		keyDown: function (e) {
			var preventDefault = false;
	
			if (this._handleSpecialKey(e) === false) {
				if (ice.dom.isBrowser('msie') !== true) {
					this._preventKeyPress = true;
				}
		
				return false;
			} 
	
			switch (e.keyCode) {
				case 27:
					// ESC
					break;
				default:
					// If not Firefox then check if event is special arrow key etc.
					// Firefox will handle this in keyPress event.
//					if (! this._browser.firefox) {
						preventDefault = !(this._handleAncillaryKey(e));
//					}
					break;
			}
	
			if (preventDefault) {
				ice.dom.preventDefault(e);
				return false;
			}
	
			return true;
		},
	// compared OK
		keyPress: function (e) {
			if (this._preventKeyPress === true) {
				this._preventKeyPress = false;
				return;
			}
			var c = null;
			if (e.which == null) {
			// IE.
				c = String.fromCharCode(e.keyCode);
			} 
			else if (e.which > 0) {
				c = String.fromCharCode(e.which);
			}
	
			if (e.ctrlKey || e.metaKey) {
				return true;
			}
	
			// Inside a br - most likely in a placeholder of a new block - delete before handling.
			var range = this.getCurrentRange(),
				br = range && ice.dom.parents(range.startContainer, 'br')[0] || null;
			if (br) {
				range.moveToNextEl(br);
//				br.parentNode.removeChild(br);
			}
	
			// Ice will ignore the keyPress event if CMD or CTRL key is also pressed
			if (c !== null && e.ctrlKey !== true && e.metaKey !== true) {
				var key = e.keyCode ? e.keyCode : e.which;
    		    switch (key) {
					case ice.dom.DOM_VK_DELETE:
//					case 32: // space
					// Handle delete key for Firefox.
						return this._handleAncillaryKey(e);
					case ice.dom.DOM_VK_ENTER:
						return this._handleEnter();
					default:
						// If we are in a deletion, move the range to the end/outside.
						return this.insert({text: c});
				}
			}
	
			return this._handleAncillaryKey(e);
		},
	
		// compared OK
		_handleEnter: function () {
			var range = this.getCurrentRange();
			if (range && !range.collapsed) {
				this._deleteContents();
			}
			return true;
		},
	// compared OK
		_handleSpecialKey: function (e) {
			var keyCode = e.which;
			if (keyCode === null) {
			// IE.
				keyCode = e.keyCode;
			}
	
			var preventDefault = false;
			switch (keyCode) {
				case 120:
				case 88:
					if (true === e.ctrlKey || true === e.metaKey) {
						this.prepareToCut();
					}
					break;
				case 67:
				case 99:
					if (true === e.ctrlKey || true === e.metaKey) {
						this.prepareToCopy();
					}
					break;
	/*				if (e.ctrlKey === true || e.metaKey === true) {
						ice.dom.preventDefault(e);
						this.hostMethods.hostCopy();
						this._deleteContents();
						return false;
					} */
		
				default:
					// Not a special key.
					break;
			} //end switch
	
			if (preventDefault === true) {
				ice.dom.preventDefault(e);
				return false;
			}
	
			return true;
		},
	
		_getIceNodes : function() {
			var classList = [];
			var self = this;
			ice.dom.each(this.changeTypes, 
				function (type, i) {
					classList.push('.' + self._getIceNodeClass(type));
				});
			classList = classList.join(',');
			return jQuery(this.element).find(classList);
		},
		
		/**
		 * Returns the first ice node in the hierarchy of the given node, or the current collapsed range.
		 * null if not in a track changes hierarchy
		 */
		currentChangeNode: function (node) {
			var selector = '.' + this._getIceNodeClass('insertType') + ', .' + this._getIceNodeClass('deleteType');
			if (!node) {
				var range = this.getCurrentRange();
				if (!range || !range.collapsed) {
					return false;
				}
				else {
					node = range.startContainer;
				}
			}
			return ice.dom.getNode(node, selector);
		},
		
		setShowChanges : function(bShow) {
			bShow = !! bShow;
			this._isVisible = bShow;
			var $body = jQuery(this.element);
			$body.toggleClass("ICE-Tracking", bShow);
			this._showTitles(bShow);
			this._updateTooltipsState();
		},
	
		reload : function() {
			this._loadFromDom();
		},
		
		hasChanges : function() {
			for (var key in this._changes) {
				var change = this._changes[key];
				if (change && change.type) {
					return true;
				}
			}
			return false;
		},
		
		countChanges : function(options) {
			var changes = this._filterChanges(options);
			return changes.count;
		},
		
		setChangeData : function(data) {
			if (null == data || (typeof data == "undefined")) {
				data = "";
			}
			this._changeData = String(data);
		},
		
		getDeleteClass : function() {
			return this._getIceNodeClass('deleteType');
		},
		
		/**
		 * called before a copy operation. 
		 * This function processes the current selection to remove the tracking style.
		 * The tracking is restored immediately after the copy operation 
		 */
		prepareToCopy: function() {
			var range = this.getCurrentRange();
			if (range && ! range.collapsed) {
				this._removeTrackingInRange(range);
			}
		},
		
		/**
		 * Preprocesses the document selection so that a deleted span is left after the browser cut
		 * @return true if there's a selection 
		 */
		prepareToCut: function() {
			var range = this.getCurrentRange(),
				hostRange = this.hostMethods.getHostRange();
			
			if (range && hostRange && range.collapsed && ! hostRange.collapsed) {
				// special case of IE showing collapsed selection when ckeditor thinks otherwise
				try {
					var data = this.hostMethods.getHostRangeData(hostRange);
					range.setStart(data.startContainer, data.startOffset);
					range.setEnd(data.endContainer, data.endOffset);
				}
				catch (e) {
					return;
				}
			}
			if (! range || range.collapsed) {
				return false;
			}
			fixSelection(range, this.element);
			var frag = range.cloneContents(),
				origRange = range.cloneRange(),
				head = frag.firstChild,tail = frag.lastChild;
//			printRange(range, "before cut");
			this.hostMethods.beforeEdit();
			
			range.collapse(false);
			range.insertNode(frag);
			range.setStartBefore(head);
//			printRange(range, "after set start before the head");
			range.setEndAfter(tail);
//			printRange(range, "after set end after the tail");
			var cid = this._startBatchChange();
			try {
				this._deleteSelection(range);
			}
			catch (e) {
				logError(e, "While trying to delete selection");
			}
			finally {
				this._endBatchChange(cid);
				this.selection.addRange(origRange);
				this._removeTrackingInRange(origRange, false);
//				printRange(this.selection.getRangeAt(0), "range after deletion");
			}
			return true;
		},

		toString : function() {
			return "ICE " + ((this.element && this.element.id) || "(no element id)");
		},
		
		_splitNode: function(node, atNode, atOffset) {
			var parent = node.parentNode,
			  	parentOffset = rangy.dom.getNodeIndex(node),
			  	doc = atNode.ownerDocument, 
			  	leftRange = doc.createRange(),
			  	left;
			  leftRange.setStart(parent, parentOffset);
			  leftRange.setEnd(atNode, atOffset);
			  left = leftRange.extractContents();
			  parent.insertBefore(left, node);
			  return node.previousSibling;
		},
		
		_triggerChange : function() {
			this.$this.trigger("change");
		},
	
		_triggerChangeText : function() {
			this.$this.trigger("textChange");
		},
		
		_updateNodeTooltip: function(node) {
			if (this.tooltips && this._isTracking && this._isVisible) {
				this._addTooltip(node);
			}
		},
	
		_acceptRejectSome : function(options, isAccept) {
			var f = (function(index, node) {
				this.acceptRejectChange(node, isAccept);
			}).bind(this);
			var changes = this._filterChanges(options);
			for (var id in changes.changes) {
				var nodes = ice.dom.find(this.element, '[' + this.attributes.changeId + '=' + id + ']');
				nodes.each(f);
			}
			if (changes.count) {
				this._triggerChange();
			}
		},
		
		/**
		 * Filters the current change set based on options
		 * @param options may contain one of:<ul>
		 * <li>exclude: an array of user ids to exclude<li>include: an array of user ids to include
		 * <li>filter: a filter function of the form function({userid, time, data}):boolean
		 * <li>verify: a boolean indicating whether or not to verify that there are matching dom nodes for each matching change
		 * </ul>
		 *	 @return an object with two members: count, changes (map of id:changeObject)
		 * @private
		 */
		_filterChanges : function(_options) {
			var count = 0, changes = {},
				options = _options || {},
				filter = options.filter,
				exclude = options.exclude ? jQuery.map(options.exclude, function(e) { return String(e); }) : null,
				include = options.include ? jQuery.map(options.include, function(e) { return String(e); }) : null,
				verify = options.verify,
				elements = null;
			for (var key in this._changes) {
				var change = this._changes[key];
				if (change && change.type) {	
					var skip = (filter && ! filter({userid: change.userid, time: change.time, data:change.data})) || 
						(exclude && exclude.indexOf(change.userid) >= 0) ||
						(include && include.indexOf(change.userid) < 0);
					if (! skip) {
						if (verify) {
							elements = ice.dom.find(this.element, "[" + this.attributes.changeId + "]");
							skip = ! elements.length;
						}
						if (! skip) {
							++count;
							changes[key] = change;
						}
					}
				}
			}
			
			return { count : count, changes : changes };
		},
		
		_loadFromDom : function() {
			this._changes = {};
//			this._userStyles = {};
//			this._styles = {};
			this._uniqueStyleIndex = 0;
			var myUserId = this.currentUser && this.currentUser.id;
			var myUserName = (this.currentUser && this.currentUser.name) || "";
			var now = (new Date()).getTime();
			// Grab class for each changeType
			var changeTypeClasses = [];
			for (var changeType in this.changeTypes) {
				changeTypeClasses.push(this._getIceNodeClass(changeType));
			}
	
			var nodes = this._getIceNodes();
			function f(i, el) {
				var styleIndex = 0;
				var ctnType = '';
				var classList = el.className.split(' ');
				//TODO optimize this - create a map of regexp
				for (var i = 0; i < classList.length; i++) {
					var styleReg = new RegExp(this.stylePrefix + '-(\\d+)').exec(classList[i]);
					if (styleReg) styleIndex = styleReg[1];
					var ctnReg = new RegExp('(' + changeTypeClasses.join('|') + ')').exec(classList[i]);
					if (ctnReg) ctnType = this._getChangeTypeFromAlias(ctnReg[1]);
				}
				var userid = ice.dom.attr(el, this.attributes.userId);
				var userName;
				if (myUserId && (userid == myUserId)) {
					userName = myUserName;
					el.setAttribute(this.attributes.userName, myUserName);
				}
				else {
					userName = el.getAttribute(this.attributes.userName);
				}
				this._setUserStyle(userid, Number(styleIndex));
				var changeid = parseInt(ice.dom.attr(el, this.attributes.changeId) || "");
				if (isNaN(changeid)) {
					changeid = this.getNewChangeId();
					el.setAttribute(this.attributes.changeId, changeid);
				}
				var timeStamp = parseInt(el.getAttribute(this.attributes.time) || "");
				if (isNaN(timeStamp)) {
					timeStamp = now;
				}
				var changeData = ice.dom.attr(el, this.attributes.changeData) || "";
				var change = {
					type: ctnType,
					userid: String(userid),// dfl: must stringify for consistency - when we read the props from dom attrs they are strings
					username: userName,
					time: timeStamp,
					data : changeData
				};
				this._changes[changeid] = change;
				this._updateNodeTooltip(el);
			}
			nodes.each(f.bind(this));
			this._triggerChange();
		},
		
		_updateUserData : function(user) {
			if (user) {
				for (var key in this._changes) {
					var change = this._changes[key];
					if (change.userid == user.id) {
						change.username = user.name;
					}
				}
			}
			var nodes = this._getIceNodes();
			nodes.each((function(i,node) {
				var match = (! user) || (user.id == node.getAttribute(this.attributes.userId));
				if (user && match) {
					node.setAttribute(this.attributes.userName, user.name);
				}
			}).bind(this));
		},
		
		_showTitles : function(bShow) {
			var nodes = this._getIceNodes();
			if (bShow) {
				jQuery(nodes).each((function(i, node) {
					this._updateNodeTooltip(node);
				}).bind(this));
			}
			else {
				jQuery(nodes).removeAttr("title");
			}
		},
		
		_updateTooltipsState: function() {
			if (this.tooltips && this._isTracking && this._isVisible) {
				if (! this._showingTips) {
					this._showingTips = true;
					var $nodes = this._getIceNodes(),
						self = this;
					$nodes.each(function(i, node) {
						self._addTooltip(node);
					});					
				}
			}
			else if (this._showingTips) {
				this._showingTips = false;
				var $nodes = this._getIceNodes();
				$nodes.each(function(i, node) {
					jQuery(node).unbind("mouseover").unbind("mouseout");
				});					
			}
		},
		
		_addTooltip: function(node) {
			jQuery(node).unbind("mouseover").unbind("mouseout").mouseover(this._tooltipMouseOver).mouseout(this._tooltipMouseOut);
		},
		
		_tooltipMouseOver: function(event) {
			var node = event.currentTarget,
				$node = jQuery(node),
				self = this;
			if (! $node.data("_tooltip_t")) {
				var to = setTimeout(function() {
					var iceNode = self.currentChangeNode(node),
						cid = iceNode && iceNode.getAttribute(self.attributes.changeId),
						change = cid && self.getChange(cid);
					if (change) {
						var type = ice.dom.hasClass(iceNode, self._getIceNodeClass("insertType")) ? "insert" : "delete";
						$node.removeData("_tooltip_t");
						self.hostMethods.showTooltip(node, {
							userName: change.username,
							userId: change.userid,
							time: change.time,
							type: type
						});
					}
				}, this.tooltipsDelay);
				$node.data("_tooltip_t", to);
			}
		},
		
		_tooltipMouseOut: function(event) {
			var node = event.currentTarget,
				$node = jQuery(node),
				to = $node.data("_tooltip_t");
			$node.removeData("_tooltip_t");
			if (to) {
				clearTimeout(to);
			}
			else {
				this.hostMethods.hideTooltip(node);
			}
		},
		
		/**
		 * Finds all the tracking nodes involved in the range and removes their tracking classes.
		 * A timeout is set to restore the tracking classes immediately.
		 * This allows the editor to copy tracked text without its style
		 */
		_removeTrackingInRange: function (range) {
			var insClass = this._getIceNodeClass('insertType'), 
				delClass = this._getIceNodeClass('deleteType'),
				clsSelector = '.' + insClass+",."+delClass,
				clsAttr = "data-ice-class",
				filter = function(node) {
					var iceNode = null, 
						$iceNode = null;
					if (node.nodeType == ice.dom.TEXT_NODE) {
						$iceNode = jQuery(node).parents(clsSelector);
					}
					else {
						var $node = jQuery(node);
						if ($node.is(clsSelector)) {
							$iceNode = $node; 
						}
						else {
							$iceNode = $node.parents(clsSelector);
						}
					}
					if (iceNode = ($iceNode && $iceNode[0])) {
						var cls = iceNode.className;
						iceNode.setAttribute(clsAttr, cls);
						iceNode.setAttribute("class", "");
						return true;
					}
					return false;
				};
			range.getNodes(null, filter);
			var el = this.element;
			setTimeout(function() {
				var /*altIns = insClass + suffix,
					altDel = delClass + suffix,
					classList = '.' + altIns + ", ." + altDel, */
					nodes = jQuery(el).find('['+ clsAttr + ']');
				nodes.each(function(i, node) {
					var cls = node.getAttribute(clsAttr);
					if (cls) {
						node.setAttribute("class", cls);
						node.removeAttribute(clsAttr);
					}
				});
				
			}, 1);
		}
		

	};
	
	var console = (window && window.console) || {
		log: function(){},
		error: function(){},
		info: function(){},
		assert:function(){},
		count: function(){}
	} ;
	
	/** Utility functions **/
	function nativeElement(e) {
		return e;
	}

	function isOnRightEdge(el, offset) {
		if (! el) {
			return false;
		}
		var type = el.nodeType;
		if (ice.dom.TEXT_NODE == type) {
			return offset && el.nodeValue && (offset >= el.nodeValue.length - 1);
		}
		if (ice.dom.ELEMENT_NODE == type) {
			return el.childNodes && el.childNodes.length && (offset >= el.childNodes.length);
		}
		return false;
	}
	
	var logError = null;
	
	function fixSelection(range, top) {
		if (! range || ! top || range.collapsed) {
			return range;
		}
		var current;
		// fix end
		try {
			while ((current = range.endContainer) && (current != top) && (range.endOffset == 0) && ! range.collapsed) {
				if (current.previousSibling) {
					range.setEndBefore(current);
				}
				else if (current.parentNode && current.parentNode != top) {
					range.setEndBefore(current.parentNode);
				}
				if (range.endContainer == current) {
					break;
				}
			}
		}
		catch (e) {
			logError(e, "fixSelection, while trying to set end");
		}

		
		try {
			while ((current = range.startContainer) && (current != top) && ! range.collapsed) {
				current = range.startContainer;

				if (current.nodeType == ice.dom.TEXT_NODE) {
					if (range.startOffset >= current.nodeValue.length) {
						range.setStartAfter(current);
					}
				}
				else { // element
					if (range.startOffset >= current.childNodes.length) {
						range.setStartAfter(current);
					}
				}
				if (range.startContainer == current) {
					break;
				}
			}
		}
		catch (e) {
			logError(e, "fixSelection, while trying to set start");
		}
	}
	
	function printRange(range, message) {
		if (! range || ! range.startContainer || ! range.endContainer) {
			return;
		}
		var parts = [];
		function printText(txt) {
			if (! txt) {
				return "";
			}
			txt = txt.replace('/\n/g', "\\n").replace('/\r/g', "").replace('\u200B', "{filler}").replace('\uFEFF', "{filler}")
			if (txt.length <= 15) {
				return txt;
			}
			return txt.substring(0, 5)+ "..." + txt.substring(txt.length - 5);
		}
		function addNode(node) {
			var str;
			if (node.nodeType === 3) {
				str = "Text:" + printText(node.nodeValue); 
			}
			else {
				var txt = node.innerText;
				str = node.nodeName + (txt ? "(" + printText(txt) + ")" :'');
			}
			parts.push("<" + str + " />");
		}
		function printNode(node, offset1, offset2) {
			if ("number" != typeof offset2) {
				offset2 = -1;
			}
			if (3 == node.nodeType) { // text
				var txt = node.nodeValue;
				parts.push(printText(txt.substring(0, offset1)));
				parts.push("|");
				if (offset2 > offset1) {
					parts.push(printText(txt.substring(offset1, offset2)));
					parts.push("|");
					parts.push(printText(txt.substring(offset2)));
				}
				else {
					parts.push(printText(txt.substring(offset1)));
				}
			}
			else if (1 == node.nodeType) {
				var i = 0,
					children = node.childNodes;
					start = (i > 6 ? i - 5 : 0);
				addNode(node);
				if (start > 0) {
					parts.push("(..." + start + " nodes)");
				}
				for (i = start; i < offset1; ++i) {
					addNode(children[i]);
				}
				parts.push("|");
				if (offset2 > offset1) {
					for (i = offset1; i < offset2; ++i) {
						addNode(children[i]);
					}
					parts.push('|');
				}
				if (offset2 > 0 && offset2 < children.length){
					var child = children[offset2];
					while (child) {
						addNode(child);
						child = child.nextSibling;
					}
				}

			}
		}
		if (range.startContainer === range.endContainer) {
			printNode(range.startContainer, range.startOffset, range.endOffset);
		}
		else {
			printNode(range.startContainer, range.startOffset);
			printNode(range.endContainer, range.endOffset);
		}
		var ret = parts.join(' ');
		if (message) {
			console.log(message + ":" + ret);
		}
		return ret;
	}


	exports.ice = this.ice || {};
	this.ice.printRange = printRange;
	exports.ice.InlineChangeEditor = InlineChangeEditor;

}).call(this);
(function () {
	var exports = this,
		dom = {},
		_browser = null;

	dom.DOM_VK_DELETE = 8;
	dom.DOM_VK_LEFT = 37;
	dom.DOM_VK_UP = 38;
	dom.DOM_VK_RIGHT = 39;
	dom.DOM_VK_DOWN = 40;
	dom.DOM_VK_ENTER = 13;
	dom.ELEMENT_NODE = 1;
	dom.ATTRIBUTE_NODE = 2;
	dom.TEXT_NODE = 3;
	dom.CDATA_SECTION_NODE = 4;
	dom.ENTITY_REFERENCE_NODE = 5;
	dom.ENTITY_NODE = 6;
	dom.PROCESSING_INSTRUCTION_NODE = 7;
	dom.COMMENT_NODE = 8;
	dom.DOCUMENT_NODE = 9;
	dom.DOCUMENT_TYPE_NODE = 10;
	dom.DOCUMENT_FRAGMENT_NODE = 11;
	dom.NOTATION_NODE = 12;
	dom.CHARACTER_UNIT = 'character';
	dom.WORD_UNIT = 'word';
	dom.BREAK_ELEMENT = 'br';
	dom.CONTENT_STUB_ELEMENTS = ['img', 'hr', 'iframe', 'param', 'link', 'meta', 'input', 'frame', 'col', 'base', 'area'];
	dom.BLOCK_ELEMENTS = ['body', 'p', 'div', 'pre', 'ul', 'ol', 'li', 'table', 'tbody', 'td', 'th', 'fieldset', 'form', 'blockquote', 'dl', 'dt', 'dd', 'dir', 'center', 'address', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6'];
	dom.TEXT_CONTAINER_ELEMENTS = ['body','p', 'div', 'pre', 'span', 'b', 'strong', 'i', 'li', 'td', 'th', 'blockquote', 'dt', 'dd', 'center', 'address', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6'];

	dom.STUB_ELEMENTS = dom.CONTENT_STUB_ELEMENTS.slice();
	dom.STUB_ELEMENTS.push(dom.BREAK_ELEMENT);

	dom.getKeyChar = function (e) {
		return String.fromCharCode(e.which);
	};
	dom.getClass = function (className, startElement, tagName) {
		if (!startElement) {
			startElement = document.body;
		}
		className = '.' + className.split(' ').join('.');
		if (tagName) {
			className = tagName + className;
		}
		return jQuery.makeArray(jQuery(startElement).find(className));
	};
	dom.getId = function (id, startElement) {
		if (!startElement) {
			startElement = document;
		}
		element = startElement.getElementById(id);
		return element;
	};
	dom.getTag = function (tagName, startElement) {
		if (!startElement) {
			startElement = document;
		}
		return jQuery.makeArray(jQuery(startElement).find(tagName));
	};
	dom.getElementWidth = function (element) {
		return element.offsetWidth;
	};
	dom.getElementHeight = function (element) {
		return element.offsetHeight;
	};
	dom.getElementDimensions = function (element) {
		var result = {
			'width': dom.getElementWidth(element),
			'height': dom.getElementHeight(element)
		};
		return result;
	};
	dom.trim = function (string) {
		return jQuery.trim(string);
	};
	dom.empty = function (element) {
		if (element) {
			return jQuery(element).empty();
		}
	};
	dom.remove = function (element) {
		if (element) {
			return jQuery(element).remove();
		}
	};
	dom.prepend = function (parent, elem) {
		jQuery(parent).prepend(elem);
	};
	dom.append = function (parent, elem) {
		jQuery(parent).append(elem);
	};
	dom.insertBefore = function (before, elem) {
		jQuery(before).before(elem);
	};
	dom.insertAfter = function (after, elem) {
		jQuery(after).after(elem);
	};
	dom.getHtml = function (element) {
		return jQuery(element).html();
	};
	dom.setHtml = function (element, content) {
		if (element) {
			jQuery(element).html(content);
		}
	};
	// Remove whitespace/newlines between nested block elements
	// that are supported by ice.
	// For example the following element with innerHTML:
	//	 <div><p> para </p> <ul>	<li> hi </li>	</ul></div>
	// Will be converted to the following:
	//	 <div><p> para </p><ul><li> hi </li></ul></div>
	dom.removeWhitespace = function(element) {
		jQuery(element).contents().filter(function() {
			// Ice supports UL and OL, so recurse in these blocks to
			// make sure that spaces don't exist between inner LI.
			if (this.nodeType != ice.dom.TEXT_NODE && this.nodeName == 'UL' || this.nodeName == 'OL') {
				dom.removeWhitespace(this);
				return false;
			} else if (this.nodeType != ice.dom.TEXT_NODE) {
				return false;
			} else {
				return !/\S/.test(this.nodeValue);
			}
		}).remove();
	};
	dom.contents = function (el) {
		return jQuery.makeArray(jQuery(el).contents());
	};
	/**
	 * Returns the inner contents of `el` as a DocumentFragment.
	 */
	dom.extractContent = function (el) {
		var frag = document.createDocumentFragment(),
			child;
		while ((child = el.firstChild)) {
			frag.appendChild(child);
		}
		return frag;
  };

	/**
	 * Returns this `node` or the first parent tracking node that matches the given `selector`.
	 */
	dom.getNode = function (node, selector) {
		if (! node) return null;
// dfl switch to DOM node from dom.js node
		node = node.$ || node;
// dfl don't test text nodes
		return (node.nodeType != 3 && dom.is(node, selector)) ? node : dom.parents(node, selector)[0] || null;
	},

	dom.getParents = function (elements, filter, stopEl) {
		var res = jQuery(elements).parents(filter);
		var ln = res.length;
		var ar = [];
		for (var i = 0; i < ln; i++) {
			if (res[i] === stopEl) {
				break;
			}
			ar.push(res[i]);
		}
		return ar;
	};
	dom.hasBlockChildren = function (parent) {
		var c = parent.childNodes.length;
		for (var i = 0; i < c; i++) {
			if (parent.childNodes[i].nodeType === dom.ELEMENT_NODE) {
				if (dom.isBlockElement(parent.childNodes[i]) === true) {
					return true;
				}
			}
		}
		return false;
	};
	dom.removeTag = function (element, selector) {
		jQuery(element).find(selector).replaceWith(function () {
			return jQuery(this).contents();
		});
		return element;
	};
	dom.stripEnclosingTags = function (content, allowedTags) {
		var c = jQuery(content);
		c.find('*').not(allowedTags).replaceWith(function () {
			var ret = jQuery();
			var $this;
			try{
				$this = jQuery(this);
				ret = $this.contents();
			} catch(e){}

			// Handling jQuery bug (which may be fixed in the official release later)
			// http://bugs.jquery.com/ticket/13401 
			if(ret.length === 0){
				$this.remove();
			}
			return ret;
		});
		return c[0];
	};
	dom.getSiblings = function (element, dir, elementNodesOnly, stopElem) {
		if (elementNodesOnly === true) {
			if (dir === 'prev') {
				return jQuery(element).prevAll();
			} else {
				return jQuery(element).nextAll();
			}
		} else {
			var elems = [];
			if (dir === 'prev') {
				while (element.previousSibling) {
					element = element.previousSibling;
					if (element === stopElem) {
						break;
					}
					elems.push(element);
				}
			} else {
				while (element.nextSibling) {
					element = element.nextSibling;
					if (element === stopElem) {
						break;
					}
					elems.push(element);
				}
			}
			return elems;
		}
	};
	dom.getNodeTextContent = function (node) {
		return jQuery(node).text();
	};
	dom.getNodeStubContent = function (node) {
		return jQuery(node).find(dom.CONTENT_STUB_ELEMENTS.join(', '));
	};
	dom.hasNoTextOrStubContent = function (node) {
		if (dom.getNodeTextContent(node).length > 0) return false;
		if (jQuery(node).find(dom.CONTENT_STUB_ELEMENTS.join(', ')).length > 0) return false;
		return true;
	};
	dom.getNodeCharacterLength = function (node) {
		return dom.getNodeTextContent(node).length + jQuery(node).find(dom.STUB_ELEMENTS.join(', ')).length;
	};
	dom.setNodeTextContent = function (node, txt) {
		return jQuery(node).text(txt);
	};
	dom.getTagName = function (node) {
		return node.tagName && node.tagName.toLowerCase() || null;
	};
	dom.getIframeDocument = function (iframe) {
		var doc = null;
		if (iframe.contentDocument) {
			doc = iframe.contentDocument;
		} else if (iframe.contentWindow) {
			doc = iframe.contentWindow.document;
		} else if (iframe.document) {
			doc = iframe.document;
		}
		return doc;
	};
	dom.isBlockElement = function (element) {
		return dom.BLOCK_ELEMENTS.indexOf(element.nodeName.toLowerCase()) != -1;
	};
	dom.isStubElement = function (element) {
		return dom.STUB_ELEMENTS.indexOf(element.nodeName.toLowerCase()) != -1;
	};
	dom.removeBRFromChild = function (node) {
		if (node && node.hasChildNodes()) {
			for(var z=0; z < node.childNodes.length ; z++) {
				var child = node.childNodes[z];
				if (child && (ice.dom.BREAK_ELEMENT == ice.dom.getTagName(child))) {
					child.parentNode.removeChild(child);
				}
			}
		}
	};
	dom.isChildOf = function (el, parent) {
		try {
			while (el && el.parentNode) {
				if (el.parentNode === parent) {
					return true;
				}
				el = el.parentNode;
			}
		} catch (e) {}
		return false;
	};
	dom.isChildOfTagName = function (el, name) {
		try {
			while (el && el.parentNode) {
				if (el.parentNode && el.parentNode.tagName && el.parentNode.tagName.toLowerCase() === name) {
					return el.parentNode;
				}
				el = el.parentNode;
			}
		} catch (e) {}
		return false;
	};


	dom.isChildOfTagNames = function (el, names) {
		try {
			while (el && el.parentNode) {
				if (el.parentNode && el.parentNode.tagName) {
					tagName = el.parentNode.tagName.toLowerCase();
					for (var i = 0; i < names.length; i++) {
						if (tagName === names[i]) {
							return el.parentNode;
						}
					}
				}
				el = el.parentNode;
			}
		} catch (e) {}
		return null;
	};

	dom.isChildOfClassName = function (el, name) {
		try {
			while (el && el.parentNode) {
				if (jQuery(el.parentNode).hasClass(name)) return el.parentNode;
				el = el.parentNode;
			}
		} catch (e) {}
		return null;
	};
	dom.cloneNode = function (elems, cloneEvents) {
		if (cloneEvents === undefined) {
			cloneEvents = true;
		}
		return jQuery(elems).clone(cloneEvents);
	};

	dom.bind = function (element, event, callback) {
		return jQuery(element).bind(event, callback);
	};

	dom.unbind = function (element, event, callback) {
		return jQuery(element).unbind(event, callback);
	};

	dom.attr = function (elements, key, val) {
		if (val) return jQuery(elements).attr(key, val);
		else return jQuery(elements).attr(key);
	};
	dom.replaceWith = function (node, replacement) {
		return jQuery(node).replaceWith(replacement);
	};
	dom.removeAttr = function (elements, name) {
		jQuery(elements).removeAttr(name);
	};
	dom.getElementsBetween = function (fromElem, toElem) {
		var elements = [];
		if (fromElem === toElem) {
			return elements;
		}
		if (dom.isChildOf(toElem, fromElem) === true) {
			var fElemLen = fromElem.childNodes.length;
			for (var i = 0; i < fElemLen; i++) {
				if (fromElem.childNodes[i] === toElem) {
					break;
				} else if (dom.isChildOf(toElem, fromElem.childNodes[i]) === true) {
					return dom.arrayMerge(elements, dom.getElementsBetween(fromElem.childNodes[i], toElem));
				} else {
					elements.push(fromElem.childNodes[i]);
				}
			}
			return elements;
		}
		var startEl = fromElem.nextSibling;
		while (startEl) {
			if (dom.isChildOf(toElem, startEl) === true) {
				elements = dom.arrayMerge(elements, dom.getElementsBetween(startEl, toElem));
				return elements;
			} else if (startEl === toElem) {
				return elements;
			} else {
				elements.push(startEl);
				startEl = startEl.nextSibling;
			}
		}
		var fromParents = dom.getParents(fromElem);
		var toParents = dom.getParents(toElem);
		var parentElems = dom.arrayDiff(fromParents, toParents, true);
		var pElemLen = parentElems.length;
		for (var j = 0; j < (pElemLen - 1); j++) {
			elements = dom.arrayMerge(elements, dom.getSiblings(parentElems[j], 'next'));
		}
		var lastParent = parentElems[(parentElems.length - 1)];
		elements = dom.arrayMerge(elements, dom.getElementsBetween(lastParent, toElem));
		return elements;
	};
	dom.getCommonAncestor = function (a, b) {
		var node = a;
		while (node) {
			if (dom.isChildOf(b, node) === true) {
				return node;
			}
			node = node.parentNode;
		}
		return null;
	};
	dom.getNextNode = function (node, container) {
		if (node) {
			while (node.parentNode) {
				if (node === container) {
					return null;
				}

				if (node.nextSibling) {
					// if next sibling is an empty text node, look further
					if (node.nextSibling.nodeType === dom.TEXT_NODE && node.nextSibling.length === 0) {
						node = node.nextSibling;
						continue;
					}

					return dom.getFirstChild(node.nextSibling);
				}
				node = node.parentNode;
			}
		}
		return null;
	};
	dom.getNextContentNode = function (node, container) {
		if (node) {
			while (node.parentNode) {
				if (node === container) {
					return null;
				}

				if (node.nextSibling && dom.canContainTextElement(dom.getBlockParent(node))) {
					// if next sibling is an empty text node, look further
					if (node.nextSibling.nodeType === dom.TEXT_NODE && node.nextSibling.length === 0) {
						node = node.nextSibling;
						continue;
					}

					return node.nextSibling;
				} else if (node.nextElementSibling) {
					return node.nextElementSibling;
				}

				node = node.parentNode;
			}
		}
		return null;
	};


	dom.getPrevNode = function (node, container) {
		if (node) {
			while (node.parentNode) {
				if (node === container) {
					return null;
				}

				if (node.previousSibling) {
					// if previous sibling is an empty text node, look further
					if (node.previousSibling.nodeType === dom.TEXT_NODE && node.previousSibling.length === 0) {
						node = node.previousSibling;
						continue;
					}

					return dom.getLastChild(node.previousSibling);
				}
				node = node.parentNode;
			}
		}
		return null;
	};
	dom.getPrevContentNode = function (node, container) {
		if (node) {
			while (node.parentNode) {
				if (node === container) {
					return null;
				}
				if (node.previousSibling && dom.canContainTextElement(dom.getBlockParent(node))) {

					// if previous sibling is an empty text node, look further
					if (node.previousSibling.nodeType === dom.TEXT_NODE && node.previousSibling.length === 0) {
						node = node.previousSibling;

						continue;
					}
					return node.previousSibling;
				} else if (node.previousElementSibling) {
					return node.previousElementSibling;
				}

				node = node.parentNode;
			}
		}
		return null;
	};
	
	/* Begin dfl */
	
	function _findPrevIndex(node, origin) {
		if (dom.TEXT_NODE == node.nodeType) {
			return node.length;
		}
		
	}
	
	function _findNextTextContainer(node, container){
		while (node) {
			if (dom.TEXT_NODE == node.nodeType) {
				return node;
			}
			for (var child = node.firstChild; child; child = child.nextSibling) {
				var ret = _findNextTextContainer(child, container);
				if (ret) {
					return ret;
				}
			}
			if (dom.isTextContainer(node)) {
				return node;
			}
			node = node.nextSibling;
		}
		return null;
	}
	
	function _findPrevTextContainer(node, container){
		while (node) {
			if (dom.TEXT_NODE == node.nodeType) {
				return node;
			}
			for (var child = node.lastChild; child; child = child.previousSibling) {
				var ret = _findPrevTextContainer(child, container);
				if (ret) {
					return ret;
				}
			}
			if (dom.isTextContainer(node)) {
				return node;
			}
			node = node.previousSibling;
		}
		return null;
	}
	
	dom.findPrevTextContainer = function(node, container) {
		if (! node || node == container) {
			return {
				node: container,
				offset: 0
			};
		}

		if (node.parentNode && dom.isTextContainer(node.parentNode)) {
			return {
				node: node.parentNode,
				offset: dom.getNodeIndex(node)
			};
		};
		while (node.previousSibling) {
			var ret = _findPrevTextContainer(node.previousSibling);
			if (ret) {
				return {
					node: ret,
					offset: dom.getNodeLength(ret)
				};
			};
			node = node.previousSibling;
		};
		
		return dom.findPrevTextContainer(node.parentNode && node.parentNode.previousSibling, container);
	};
	
	dom.findNextTextContainer = function(node, container) {
		if (! node || node == container) {
			return {
				node: container,
				offset: dom.getNodeLength(container)
			};
		}
		if (node.parentNode && dom.isTextContainer(node.parentNode)) {
			return {
				node: node.parentNode,
				offset: dom.getNodeIndex(node) + 1
			};
		};
		while (node.nextSibling) {
			var ret = _findNextTextContainer(node.nextSibling);
			if (ret) {
				return {
					node: ret,
					offset: 0
				};
			};
			node = node.previousSibling;
		};
		
		return dom.findNextTextContainer(node.parentNode && node.parentNode.nextSibling, container);
	};
	
	dom.getNodeLength = function(node) {
		return node ? 
				(dom.TEXT_NODE == node.nodeType ? 
						node.length : ((node.childNodes && node.childNodes.length) || 0)) :
				0;
	};
	
	dom.isTextContainer = function(node) {
		return (node && (dom.TEXT_NODE == node.nodeType) || dom.TEXT_CONTAINER_ELEMENTS.indexOf((node.nodeName || "").toLowerCase()) >= 0);
	};
	
	dom.getNodeIndex = function(node) {
		var i = 0;
		while( (node = node.previousSibling) ) {
			++i;
		}
		return i;
	};
	
	/* end dfl */

	dom.canContainTextElement = function (element) {
		if (element && element.nodeName) {
			return dom.TEXT_CONTAINER_ELEMENTS.lastIndexOf(element.nodeName.toLowerCase()) != -1;
		} else {
			return false;
		}
	};

	dom.getFirstChild = function (node) {
		if (node.firstChild) {
			if (node.firstChild.nodeType === dom.ELEMENT_NODE) {
				return dom.getFirstChild(node.firstChild);
			} else {
				return node.firstChild;
			}
		}
		return node;
	};
	dom.getLastChild = function (node) {
		if (node.lastChild) {
			if (node.lastChild.nodeType === dom.ELEMENT_NODE) {
				return dom.getLastChild(node.lastChild);
			} else {
				return node.lastChild;
			}
		}
		return node;
	};
	dom.removeEmptyNodes = function (parent, callback) {
		var elems = jQuery(parent).find(':empty');
		var i = elems.length;
		while (i > 0) {
			i--;
			if (dom.isStubElement(elems[i]) === false) {
				if (!callback || callback.call(this, elems[i]) !== false) {
					dom.remove(elems[i]);
				}
			}
		}
	};
	dom.create = function (html) {
		return jQuery(html)[0];
	};
	dom.find = function (parent, exp) {
		return jQuery(parent).find(exp);
	};
	dom.children = function (parent, exp) {
		return jQuery(parent).children(exp);
	};
	dom.parent = function (child, exp) {
		return jQuery(child).parent(exp)[0];
	};
	dom.parents = function (child, exp) {
		return jQuery(child).parents(exp);
	};
	dom.is = function (node, exp) {
		return jQuery(node).is(exp);
	};
	dom.extend = function (deep, target, object1, object2) {
		return jQuery.extend.apply(this, arguments);
	};
	dom.walk = function (elem, callback, lvl) {
		if (!elem) {
			return;
		}
		if (!lvl) {
			lvl = 0;
		}
		var retVal = callback.call(this, elem, lvl);
		if (retVal === false) {
			return;
		}
		if (elem.childNodes && elem.childNodes.length > 0) {
			dom.walk(elem.firstChild, callback, (lvl + 1));
		} else if (elem.nextSibling) {
			dom.walk(elem.nextSibling, callback, lvl);
		} else if (elem.parentNode && elem.parentNode.nextSibling) {
			dom.walk(elem.parentNode.nextSibling, callback, (lvl - 1));
		}
	};
	dom.revWalk = function (elem, callback) {
		if (!elem) {
			return;
		}
		var retVal = callback.call(this, elem);
		if (retVal === false) {
			return;
		}
		if (elem.childNodes && elem.childNodes.length > 0) {
			dom.walk(elem.lastChild, callback);
		} else if (elem.previousSibling) {
			dom.walk(elem.previousSibling, callback);
		} else if (elem.parentNode && elem.parentNode.previousSibling) {
			dom.walk(elem.parentNode.previousSibling, callback);
		}
	};
	dom.setStyle = function (element, property, value) {
		if (element) {
			jQuery(element).css(property, value);
		}
	};
	dom.getStyle = function (element, property) {
		return jQuery(element).css(property);
	};
	dom.hasClass = function (element, className) {
		return jQuery(element).hasClass(className);
	};
	dom.addClass = function (element, classNames) {
		jQuery(element).addClass(classNames);
	};
	dom.removeClass = function (element, classNames) {
		jQuery(element).removeClass(classNames);
	};
	dom.preventDefault = function (e) {
		e.preventDefault();
		dom.stopPropagation(e);
	};
	dom.stopPropagation = function (e) {
		e.stopPropagation();
	};
	dom.noInclusionInherits = function (child, parent) {
		if (parent instanceof String || typeof parent === 'string') {
			parent = window[parent];
		}
		if (child instanceof String || typeof child === 'string') {
			child = window[child];
		}
		var above = function () {};
		if (dom.isset(parent) === true) {
			for (value in parent.prototype) {
				if (child.prototype[value]) {
					above.prototype[value] = parent.prototype[value];
					continue;
				}
				child.prototype[value] = parent.prototype[value];
			}
		}
		if (child.prototype) {
			above.prototype.constructor = parent;
			child.prototype['super'] = new above();
		}
	};

	dom.each = function (val, callback) {
		jQuery.each(val, function (i, el) {
			callback.call(this, i, el);
		});
	};

	dom.foreach = function (value, cb) {
		if (value instanceof Array || value instanceof NodeList || typeof value.length != 'undefined' && typeof value.item != 'undefined') {
			var len = value.length;
			for (var i = 0; i < len; i++) {
				var res = cb.call(this, i, value[i]);
				if (res === false) {
					break;
				}
			}
		} else {
			for (var id in value) {
				if (value.hasOwnProperty(id) === true) {
					var res = cb.call(this, id);
					if (res === false) {
						break;
					}
				}
			}
		}
	};
	dom.isBlank = function (value) {
		if (!value || /^\s*$/.test(value)) {
			return true;
		}
		return false;
	};
	dom.isFn = function (f) {
		if (typeof f === 'function') {
			return true;
		}
		return false;
	};
	dom.isObj = function (v) {
		if (v !== null && typeof v === 'object') {
			return true;
		}
		return false;
	};
	dom.isset = function (v) {
		if (typeof v !== 'undefined' && v !== null) {
			return true;
		}
		return false;
	};
	dom.isArray = function (v) {
		return jQuery.isArray(v);
	};
	dom.isNumeric = function (str) {
		var result = str.match(/^\d+$/);
		if (result !== null) {
			return true;
		}
		return false;
	};
	dom.getUniqueId = function () {
		var timestamp = (new Date()).getTime();
		var random = Math.ceil(Math.random() * 1000000);
		var id = timestamp + '' + random;
		return id.substr(5, 18).replace(/,/, '');
	};
	dom.inArray = function (needle, haystack) {
		var hln = haystack.length;
		for (var i = 0; i < hln; i++) {
			if (needle === haystack[i]) {
				return true;
			}
		}
		return false;
	};
	dom.arrayDiff = function (array1, array2, firstOnly) {
		var al = array1.length;
		var res = [];
		for (var i = 0; i < al; i++) {
			if (dom.inArray(array1[i], array2) === false) {
				res.push(array1[i]);
			}
		}
		if (firstOnly !== true) {
			al = array2.length;
			for (var i = 0; i < al; i++) {
				if (dom.inArray(array2[i], array1) === false) {
					res.push(array2[i]);
				}
			}
		}
		return res;
	};
	dom.arrayMerge = function (array1, array2) {
		var c = array2.length;
		for (var i = 0; i < c; i++) {
			array1.push(array2[i]);
		}
		return array1;
	};
	/**
	 * Removes allowedTags from the given content html string. If allowedTags is a string, then it
	 * is expected to be a selector; otherwise, it is expected to be array of string tag names.
	 */
	dom.stripTags = function (content, allowedTags) {
		if (typeof allowedTags === "string") {
			var c = jQuery('<div>' + content + '</div>');
			c.find('*').not(allowedTags).remove();
			return c.html();
		} else {
			var match;
			var re = new RegExp(/<\/?(\w+)((\s+\w+(\s*=\s*(?:".*?"|'.*?'|[^'">\s]+))?)+\s*|\s*)\/?>/gim);
			var resCont = content;
			while ((match = re.exec(content)) != null) {
				if (dom.isset(allowedTags) === false || dom.inArray(match[1], allowedTags) !== true) {
					resCont = resCont.replace(match[0], '');
				}
			}
			return resCont;
		}
	};
	
	dom.browser = function () {
		if (_browser) {
			return jQuery.extend({}, _browser);
		}
		
		_browser = (function() {
			function uaMatch( ua ) {
				ua = ua.toLowerCase();
	
				var match = /(chrome)[ \/]([\w.]+)/.exec( ua ) ||
					/(webkit)[ \/]([\w.]+)/.exec( ua ) ||
					/(opera)(?:.*version|)[ \/]([\w.]+)/.exec( ua ) ||
					/(msie) ([\w.]+)/.exec( ua ) ||
					ua.indexOf("compatible") < 0 && /(mozilla)(?:.*? rv:([\w.]+)|)/.exec( ua ) ||
					[];
	
				return {
					browser: match[ 1 ] || "",
					version: match[ 2 ] || "0"
				};
			};
	
			var ua = navigator.userAgent.toLowerCase(),
				matched = uaMatch(ua),
				browser = {
					type: "unknown",
					version : 0,
					msie: false
				};
	
			if ( matched.browser ) {
				browser[ matched.browser ] = true;
				browser.version = matched.version || 0;
				browser.type = matched.browser;
			}
	
			// Chrome is Webkit, but Webkit is also Safari.
			if ( browser.chrome ) {
				browser.webkit = true;
			} else if ( browser.webkit ) {
				browser.safari = true;
			}
			if (browser.webkit) {
				browser.type = "webkit";
			}
			browser.firefox = (/firefox/.test(ua) == true);
			if (! browser.msie) {
				browser.msie = !! /trident/.test(ua); 
			}
			
			return browser;
		})();
		
		return jQuery.extend({}, _browser);
	};

	dom.getBrowserType = function () {
		if (this._browserType === null) {
			var tests = ['msie', 'firefox', 'chrome', 'safari'];
			var tln = tests.length;
			for (var i = 0; i < tln; i++) {
				var r = new RegExp(tests[i], 'i');
				if (r.test(navigator.userAgent) === true) {
					this._browserType = tests[i];
					return this._browserType;
				}
			}

			this._browserType = 'other';
		}
		return this._browserType;
	};
	dom.getWebkitType = function(){
	if(dom.browser().type !== "webkit") {
		console.log("Not a webkit!");
		return false;
	}
		var isSafari = Object.prototype.toString.call(window.HTMLElement).indexOf('Constructor') > 0;
	if(isSafari) return "safari";
	return "chrome";
	};
	dom.isBrowser = function (browser) {
		return (dom.browser().type === browser);
	};

	dom.getBlockParent = function (node, container) {
		if (dom.isBlockElement(node) === true) {
			return node;
		}
		if (node) {
			while (node.parentNode) {
				node = node.parentNode;

				if (dom.isBlockElement(node) === true) {
					return node;
				}
				if (node === container) {
					return null;
				}
			}
		}
		return null;
	};
	dom.findNodeParent = function (node, selector, container) {
		if (node) {
			while (node.parentNode) {
				if (node === container) {
					return null;
				}

				if (dom.is(node, selector) === true) {
					return node;
				}
				node = node.parentNode;
			}
		}
		return null;
	};
	dom.onBlockBoundary = function (leftContainer, rightContainer, blockEls) {
		if (!leftContainer || !rightContainer) return false
		var bleft = dom.isChildOfTagNames(leftContainer, blockEls) || dom.is(leftContainer, blockEls.join(', ')) && leftContainer || null;
		var bright = dom.isChildOfTagNames(rightContainer, blockEls) || dom.is(rightContainer, blockEls.join(', ')) && rightContainer || null;
		return (bleft !== bright);
	};

	dom.isOnBlockBoundary = function (leftContainer, rightContainer, container) {
		if (!leftContainer || !rightContainer) return false
		var bleft = dom.getBlockParent(leftContainer, container) || dom.isBlockElement(leftContainer, container) && leftContainer || null;
		var bright = dom.getBlockParent(rightContainer, container) || dom.isBlockElement(rightContainer, container) && rightContainer || null;
		return (bleft !== bright);
	};

	dom.mergeContainers = function (node, mergeToNode) {
		if (!node || !mergeToNode) return false;

		if (node.nodeType === dom.TEXT_NODE || dom.isStubElement(node)) {
			// Move only this node.
			mergeToNode.appendChild(node);
		} else if (node.nodeType === dom.ELEMENT_NODE) {
			// Move all the child nodes to the new parent.
			while (node.firstChild) {
				mergeToNode.appendChild(node.firstChild);
			}

			dom.remove(node);
		}
		return true;
	};

	dom.mergeBlockWithSibling = function (range, block, next) {
		var siblingBlock = next ? jQuery(block).next().get(0) : jQuery(block).prev().get(0); // block['nextSibling'] : block['previousSibling'];
		if (next) dom.mergeContainers(siblingBlock, block);
		else dom.mergeContainers(block, siblingBlock);
		range.collapse(true);
		return true;
	};

	dom.date = function (format, timestamp, tsIso8601) {
		if (timestamp === null && tsIso8601) {
			timestamp = dom.tsIso8601ToTimestamp(tsIso8601);
			if (!timestamp) {
				return;
			}
		}
		var date = new Date(timestamp);
		var formats = format.split('');
		var fc = formats.length;
		var dateStr = '';
		for (var i = 0; i < fc; i++) {
			var r = '';
			var f = formats[i];
			switch (f) {
				case 'D':
				case 'l':
					var names = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
					r = names[date.getDay()];
					if (f === 'D') {
						r = r.substring(0, 3);
					}
					break;
				case 'F':
				case 'm':
					r = date.getMonth() + 1;
					if (r < 10) r = '0' + r;
					break;
				case 'M':
					months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
					r = months[date.getMonth()];
					if (f === 'M') {
						r = r.substring(0, 3);
					}
					break;
				case 'd':
					r = date.getDate();
					break;
				case 'S':
					r = dom.getOrdinalSuffix(date.getDate());
					break;
				case 'Y':
					r = date.getFullYear();
					break;
				case 'y':
					r = date.getFullYear();
					r = r.toString().substring(2);
					break;
				case 'H':
					r = date.getHours();
					break;
				case 'h':
					r = date.getHours();
					if (r === 0) {
						r = 12;
					} else if (r > 12) {
						r -= 12;
					}
					break;
				case 'i':
					r = dom.addNumberPadding(date.getMinutes());
					break;
				case 'a':
					r = 'am';
					if (date.getHours() >= 12) {
						r = 'pm';
					}
					break;
				default:
					r = f;
					break;
			}
			dateStr += r;
		}
		return dateStr;
	};
	dom.getOrdinalSuffix = function (number) {
		var suffix = '';
		var tmp = (number % 100);
		if (tmp >= 4 && tmp <= 20) {
			suffix = 'th';
		} else {
			switch (number % 10) {
				case 1:
					suffix = 'st';
					break;
				case 2:
					suffix = 'nd';
					break;
				case 3:
					suffix = 'rd';
					break;
				default:
					suffix = 'th';
					break;
			}
		}
		return suffix;
	};
	dom.addNumberPadding = function (number) {
		if (number < 10) {
			number = '0' + number;
		}
		return number;
	};
	dom.tsIso8601ToTimestamp = function (tsIso8601) {
		var regexp = /(\d\d\d\d)(?:-?(\d\d)(?:-?(\d\d)(?:[T ](\d\d)(?::?(\d\d)(?::?(\d\d)(?:\.(\d+))?)?)?(?:Z|(?:([-+])(\d\d)(?::?(\d\d))?)?)?)?)?)?/;
		var d = tsIso8601.match(new RegExp(regexp));
		if (d) {
			var date = new Date();
			date.setDate(d[3]);
			date.setFullYear(d[1]);
			date.setMonth(d[2] - 1);
			date.setHours(d[4]);
			date.setMinutes(d[5]);
			date.setSeconds(d[6]);
			var offset = (d[9] * 60);
			if (d[8] === '+') {
				offset *= -1;
			}
			offset -= date.getTimezoneOffset();
			var timestamp = (date.getTime() + (offset * 60 * 1000));
			return timestamp;
		}
		return null;
	};
	
	dom.normalizeNode = function(node) {
		if (! node) {
			return;
		}
		if ("function" == typeof node.normalize) {
			return node.normalize();
		}
		return this._myNormalizeNode(node);
	};

	function _myNormalizeNode(node) {
		if (! node) {
			return;
		}
		var ELEMENT_NODE = 1;
		var TEXT_NODE = 3;
		var child = node.firstChild;
		while (child) {
			if (child.nodeType == ELEMENT_NODE) {
				this._myNormalizeNode(child);
			}
			else if (child.nodeType == TEXT_NODE) { 
				var next;
				while ((next = child.nextSibling) && next.nodeType == TEXT_NODE) { 
					var value = next.nodeValue;
					if (value != null && value.length) {
						child.nodeValue = child.nodeValue + value;
					}
					node.removeChild(next);
				}
			}
			child = child.nextSibling;
		}
	};	


	exports.dom = dom;

}).call(this.ice);
(function () {

	var exports = this,
		Selection;

	Selection = function (env) {
		this._selection = null;
		this.env = env;
	
		this._initializeRangeLibrary();
		this._getSelection();
	};

	Selection.prototype = {

	/**
	 * Returns the selection object for the current browser.
	 */
	_getSelection: function () {
		if (this._selection) {
			this._selection.refresh();
		}
		else if (this.env.frame) {
			this._selection = rangy.getSelection(this.env.frame);
		}
		else {
			this._selection = rangy.getSelection();
		}
		return this._selection;
	},

	/**
	 * Creates a range object.
	 */
	createRange: function () {
		return rangy.createRange(this.env.document);
	},

	/**
	 * Returns the range object at the specified position. The current range object
	 * is at position 0. Note - currently only setting single range in `addRange` so
	 * position 0 will be the only allocation filled.
	 */
	getRangeAt: function (pos) {
		var ret = null;
		try {
			this._selection.refresh();
			ret =this._selection.getRangeAt(pos);
		} 
		catch (e) {
			this._selection = null;
			ret = this._getSelection().getRangeAt(0);
		}

		return ret;
	},

	/**
	 * Adds the specified range to the current selection. Note - only supporting setting
	 * a single range, so the previous range gets evicted.
	 */
	addRange: function (range) {
		this._selection || (this._selection = this._getSelection());
		this._selection.setSingleRange(range);
		this._selection.ranges = [range];
		return;
	},

	/**
	 * Initialize and extend the `rangy` library with some custom functionality.
	 */
	_initializeRangeLibrary: function () {
		var self = this;

		rangy.init();
		rangy.config.checkSelectionRanges = false;

		var move = function (range, unitType, units, isStart) {
		if (units === 0) {
		  return;
		}

		switch (unitType) {
			case ice.dom.CHARACTER_UNIT:
			if (units > 0) {
				range.moveCharRight(isStart, units);
			} else {
				range.moveCharLeft(isStart, units * -1);
			}
			break;

			case ice.dom.WORD_UNIT:
			default:
			// Removed. TODO: possibly refactor or re-implement.
			break;
		}
		};

		/**
		 * Moves the start of the range using the specified `unitType`, by the specified
		 * number of `units`. Defaults to `CHARACTER_UNIT` and units of 1.
		 */
		rangy.rangePrototype.moveStart = function (unitType, units) {
		move(this, unitType, units, true);
		};

		/**
		 * Moves the end of the range using the specified `unitType`, by the specified
		 * number of `units`.
		 */
		rangy.rangePrototype.moveEnd = function (unitType, units) {
		move(this, unitType, units, false);
		};

		/**
		 * Depending on the given `start` boolean, sets the start or end containers
		 * to the given `container` with `offset` units.
		 */
		rangy.rangePrototype.setRange = function (start, container, offset) {
			if (start) {
				this.setStart(container, offset);
			} 
			else {
				this.setEnd(container, offset);
			}
		};

		/**
		 * Depending on the given `moveStart` boolean, moves the start or end containers
		 * to the left by the given number of character `units`. Use the following
		 * example as a demonstration for where the range will fall as it moves in and
		 * out of tag boundaries (where "|" is the marked range):
		 *
		 * test <em>it</em> o|ut
		 * test <em>it</em> |out
		 * test <em>it</em>| out
		 * test <em>i|t</em> out
		 * test <em>|it</em> out
		 * test| <em>it</em> out
		 * tes|t <em>it</em> out
		 * 
		 * A range could be mapped in one of two ways:
		 * 
		 * (1) If a startContainer is a Node of type Text, Comment, or CDATASection, then startOffset
		 * is the number of characters from the start of startNode. For example, the following
		 * are the range properties for `<p>te|st</p>` (where "|" is the collapsed range):
		 * 
		 * startContainer: <TEXT>test<TEXT>
		 * startOffset: 2
		 * endContainer: <TEXT>test<TEXT>
		 * endOffset: 2
		 * 
		 * (2) For other Node types, startOffset is the number of child nodes between the start of
		 * the startNode. Take the following html fragment:
		 * 
		 * `<p>some <span>test</span> text</p>`
		 * 
		 * If we were working with the following range properties:
		 * 
		 * startContainer: <p>
		 * startOffset: 2
		 * endContainer: <p>
		 * endOffset: 2
		 * 
		 * Since <p> is an Element node, the offsets are based on the offset in child nodes of <p> and
		 * the range is selecting the second child - the <span> tag.
		 * 
		 * <p><TEXT>some </TEXT><SPAN>test</SPAN><TEXT> text</TEXT></p>
		 */
		rangy.rangePrototype.moveCharLeft = function (moveStart, units) {
			var container, offset;
	
			if (moveStart) {
				container = this.startContainer;
				offset = this.startOffset;
			} else {
				container = this.endContainer;
				offset = this.endOffset;
			}
	
			// Handle the case where the range conforms to (2) (noted in the comment above).
			if (container.nodeType === ice.dom.ELEMENT_NODE) {
				if (container.hasChildNodes()) {
				container = container.childNodes[offset];
	
				container = this.getPreviousTextNode(container);
	
				// Get the previous text container that is not an empty text node.
				while (container && container.nodeType == ice.dom.TEXT_NODE && container.nodeValue === "") {
					container = this.getPreviousTextNode(container);
				}
	
				offset = container.data.length - units;
				} else {
				offset = units * -1;
				}
			} else {
				offset -= units;
			}
	
			if (offset < 0) {
				// We need to move to a previous selectable container.
				while (offset < 0) {
					var skippedBlockElem = [];
		
					container = this.getPreviousTextNode(container, skippedBlockElem);
		
					// We are at the beginning/out of the editable - break.
					if (!container) {
						return;
					}
		
					if (container.nodeType === ice.dom.ELEMENT_NODE) {
						continue;
					}
		
					offset += container.data.length;
				}
			}
	
			this.setRange(moveStart, container, offset);
		};

		/**
		 * Depending on the given `moveStart` boolean, moves the start or end containers
		 * to the right by the given number of character `units`. Use the following
		 * example as a demonstration for where the range will fall as it moves in and
		 * out of tag boundaries (where "|" is the marked range):
		 *
		 * tes|t <em>it</em> out
		 * test| <em>it</em> out
		 * test |<em>it</em> out
		 * test <em>i|t</em> out
		 * test <em>it|</em> out
		 * test <em>it</em> |out
		 * 
		 * A range could be mapped in one of two ways:
		 * 
		 * (1) If a startContainer is a Node of type Text, Comment, or CDATASection, then startOffset
		 * is the number of characters from the start of startNode. For example, the following
		 * are the range properties for `<p>te|st</p>` (where "|" is the collapsed range):
		 * 
		 * startContainer: <TEXT>test<TEXT>
		 * startOffset: 2
		 * endContainer: <TEXT>test<TEXT>
		 * endOffset: 2
		 * 
		 * (2) For other Node types, startOffset is the number of child nodes between the start of
		 * the startNode. Take the following html fragment:
		 * 
		 * `<p>some <span>test</span> text</p>`
		 * 
		 * If we were working with the following range properties:
		 * 
		 * startContainer: <p>
		 * startOffset: 2
		 * endContainer: <p>
		 * endOffset: 2
		 * 
		 * Since <p> is an Element node, the offsets are based on the offset in child nodes of <p> and
		 * the range is selecting the second child - the <span> tag.
		 * 
		 * <p><TEXT>some </TEXT><SPAN>test</SPAN><TEXT> text</TEXT></p>
		 * Fixed by dfl to handle cases when there's no next container
		 */
		rangy.rangePrototype.moveCharRight = function (moveStart, units) {
			var container, offset;
	
			if (moveStart) {
				container = this.startContainer;
				offset = this.startOffset;
			} else {
				container = this.endContainer;
				offset = this.endOffset;
			}
	
			if (container.nodeType === ice.dom.ELEMENT_NODE) {
				container = container.childNodes[offset];
				if (container.nodeType !== ice.dom.TEXT_NODE) {
				container = this.getNextTextNode(container);
				}
	
				offset = units;
			} else {
				offset += units;
			}
	
			var diff = (offset - container.data.length);
			if (diff > 0) {
				var skippedBlockElem = [];
				// We need to move to the next selectable container.
				while (diff > 0) {
					container = this.getNextContainer(container, skippedBlockElem);
					if (! container) {
						return;
					}
		
					if (container.nodeType === ice.dom.ELEMENT_NODE) {
						continue;
					}
		
					if (container.data.length >= diff) {
						// We found a container with enough content to select.
						break;
					} else if (container.data.length > 0) {
						// Container does not have enough content,
						// find the next one.
						diff -= container.data.length;
					}
				}
	
				offset = diff;
			}
			this.setRange(moveStart, container, offset);
		};

		/**
		 * Returns the deepest next container that the range can be extended to.
		 * For example, if the next container is an element that contains text nodes,
		 * the the container's firstChild is returned.
		 */
		rangy.rangePrototype.getNextContainer = function (container, skippedBlockElem) {
			if (!container) {
				return null;
			}
	
			while (container.nextSibling) {
				container = container.nextSibling;
				if (container.nodeType !== ice.dom.TEXT_NODE) {
				var child = this.getFirstSelectableChild(container);
				if (child !== null) {
					return child;
				}
				} else if (this.isSelectable(container) === true) {
				return container;
				}
			}
	
			// Look at parents next sibling.
			while (container && !container.nextSibling) {
				container = container.parentNode;
			}
	
			if (!container) {
				return null;
			}
	
			container = container.nextSibling;
			if (this.isSelectable(container) === true) {
				return container;
			} else if (skippedBlockElem && ice.dom.isBlockElement(container) === true) {
				skippedBlockElem.push(container);
			}
	
			var selChild = this.getFirstSelectableChild(container);
			if (selChild !== null) {
				return selChild;
			}
	
			return this.getNextContainer(container, skippedBlockElem);
		};

		/**
		 * Returns the deepest previous container that the range can be extended to.
		 * For example, if the previous container is an element that contains text nodes,
		 * then the container's lastChild is returned.
		 */
		rangy.rangePrototype.getPreviousContainer = function (container, skippedBlockElem) {
			if (!container) {
				return null;
			}
	
			while (container.previousSibling) {
				container = container.previousSibling;
				if (container.nodeType !== ice.dom.TEXT_NODE) {
				if (ice.dom.isStubElement(container) === true) {
					return container;
				} else {
					var child = this.getLastSelectableChild(container);
					if (child !== null) {
					return child;
					}
				}
				} else if (this.isSelectable(container) === true) {
				return container;
				}
			}
	
			// Look at parents next sibling.
			while (container && !container.previousSibling) {
				container = container.parentNode;
			}
	
			if (!container) {
				return null;
			}
	
			container = container.previousSibling;
			if (this.isSelectable(container) === true) {
				return container;
			} 
			else if (skippedBlockElem && ice.dom.isBlockElement(container) === true) {
				skippedBlockElem.push(container);
			}
	
			var selChild = this.getLastSelectableChild(container);
			if (selChild !== null) {
				return selChild;
			}
			return this.getPreviousContainer(container, skippedBlockElem);
		};
	
		rangy.rangePrototype.getNextTextNode = function (container) {
			if (container.nodeType === ice.dom.ELEMENT_NODE) {
				if (container.childNodes.length !== 0) {
				return this.getFirstSelectableChild(container);
				}
			}
	
			container = this.getNextContainer(container);
			if (container.nodeType === ice.dom.TEXT_NODE) {
				return container;
			}
	
			return this.getNextTextNode(container);
		};
	
		rangy.rangePrototype.getPreviousTextNode = function (container, skippedBlockEl) {
			container = this.getPreviousContainer(container, skippedBlockEl);
			if (container.nodeType === ice.dom.TEXT_NODE) {
				return container;
			}
	
			return this.getPreviousTextNode(container, skippedBlockEl);
		};
	
		rangy.rangePrototype.getFirstSelectableChild = function (element) {
			if (element) {
				if (element.nodeType !== ice.dom.TEXT_NODE) {
				var child = element.firstChild;
				while (child) {
					if (this.isSelectable(child) === true) {
					return child;
					} else if (child.firstChild) {
					// This node does have child nodes.
					var res = this.getFirstSelectableChild(child);
					if (res !== null) {
						return res;
					} else {
						child = child.nextSibling;
					}
					} else {
					child = child.nextSibling;
					}
				}
				} else {
				// Given element is a text node so return it.
				return element;
				}
			}
			return null;
		};

		rangy.rangePrototype.getLastSelectableChild = function (element) {
			if (element) {
				if (element.nodeType !== ice.dom.TEXT_NODE) {
				var child = element.lastChild;
				while (child) {
					if (this.isSelectable(child) === true) {
					return child;
					} else if (child.lastChild) {
					// This node does have child nodes.
					var res = this.getLastSelectableChild(child);
					if (res !== null) {
						return res;
					} else {
						child = child.previousSibling;
					}
					} else {
					child = child.previousSibling;
					}
				}
				} else {
				// Given element is a text node so return it.
				return element;
				}
			}
			return null;
		};

		rangy.rangePrototype.isSelectable = function (container) {
			if (container && container.nodeType === ice.dom.TEXT_NODE && container.data.length !== 0) {
				return true;
			}
			return false;
		};

		rangy.rangePrototype.getHTMLContents = function (clonedSelection) {
			if (!clonedSelection) {
				clonedSelection = this.cloneContents();
			}
			var div = self.env.document.createElement('div');
			div.appendChild(clonedSelection.cloneNode(true));
			return div.innerHTML;
			};
	
			rangy.rangePrototype.getHTMLContentsObj = function () {
			return this.cloneContents();
			};
		}
	};

	exports.Selection = Selection;

}).call(this.ice);
(function() {

	var exports = this,
		Bookmark;

	Bookmark = function(env, range, keepOldBookmarks) {

		this.env = env;
		this.element = env.element;
		this.selection = this.env.selection;

		// Remove all bookmarks?
		if (!keepOldBookmarks) {
			this.removeBookmarks(this.element);
		}

		var currRange = range || this.selection.getRangeAt(0),
			range = currRange.cloneRange(),
			startContainer = range.startContainer,
			startOffset = range.startOffset,
			endOffset = range.endOffset,
			tmp;

		// Collapse to the end of range.
		range.collapse(false);

		var endBookmark = this.env.document.createElement('span');
		endBookmark.style.display = 'none';
		ice.dom.setHtml(endBookmark, '&nbsp;');
		ice.dom.addClass(endBookmark, 'iceBookmark iceBookmark_end');
		endBookmark.setAttribute('iceBookmark', 'end');
		range.insertNode(endBookmark);
		if (!ice.dom.isChildOf(endBookmark, this.element)) {
			this.element.appendChild(endBookmark);
		}

		// Move the range to where it was before.
		range.setStart(startContainer, startOffset);
		range.collapse(true);

		// Create the start bookmark.
		var startBookmark = this.env.document.createElement('span');
		startBookmark.style.display = 'none';
		ice.dom.addClass(startBookmark, 'iceBookmark iceBookmark_start');
		ice.dom.setHtml(startBookmark, '&nbsp;');
		startBookmark.setAttribute('iceBookmark', 'start');
		try {
			range.insertNode(startBookmark);

			// Make sure start and end are in correct position.
			if (startBookmark.previousSibling === endBookmark) {
				// Reverse..
				tmp = startBookmark;
				startBookmark = endBookmark;
				endBookmark = tmp;
			}
		} catch (e) {
			// NS_ERROR_UNEXPECTED: I believe this is a Firefox bug.
			// It seems like if the range is collapsed and the text node is empty
			// (i.e. length = 0) then Firefox tries to split the node for no reason and fails...
			ice.dom.insertBefore(endBookmark, startBookmark);
		}

		if (ice.dom.isChildOf(startBookmark, this.element) === false) {
			if (this.element.firstChild) {
				ice.dom.insertBefore(this.element.firstChild, startBookmark);
			} else {
				// Should not happen...
				this.element.appendChild(startBookmark);
			}
		}

		if (!endBookmark.previousSibling) {
			tmp = this.env.document.createTextNode('');
			ice.dom.insertBefore(endBookmark, tmp);
		}

		// The original range object must be changed.
		if (!startBookmark.nextSibling) {
			tmp = this.env.document.createTextNode('');
			ice.dom.insertAfter(startBookmark, tmp);
		}

		currRange.setStart(startBookmark.nextSibling, 0);
		currRange.setEnd(endBookmark.previousSibling, (endBookmark.previousSibling.length || 0));

		this.start = startBookmark;
		this.end = endBookmark;
	};

	Bookmark.prototype = {

		selectBookmark: function() {
			var range = this.selection.getRangeAt(0),
				startPos = null,
				endPos = null,
				startOffset = 0,
				endOffset = null,
				parent = this.start && this.start.parentNode;

			if (this.start.nextSibling === this.end || ice.dom.getElementsBetween(this.start, this.end).length === 0) {
				// Bookmark is collapsed.
				if (this.end.nextSibling) {
					startPos = ice.dom.getFirstChild(this.end.nextSibling);
				} else if (this.start.previousSibling) {
					startPos = ice.dom.getFirstChild(this.start.previousSibling);
					if (startPos.nodeType === ice.dom.TEXT_NODE) {
						startOffset = startPos.length;
					}
				} else {
					// Create a text node in parent.
					this.end.parentNode.appendChild(this.env.document.createTextNode(''));
					startPos = ice.dom.getFirstChild(this.end.nextSibling);
				}
			} else {
				if (this.start.nextSibling) {
					startPos = ice.dom.getFirstChild(this.start.nextSibling);
				} else {
					if (!this.start.previousSibling) {
						var tmp = this.env.document.createTextNode('');
						ice.dom.insertBefore(this.start, tmp);
					}

					startPos = ice.dom.getLastChild(this.start.previousSibling);
					startOffset = startPos.length;
				}

				if (this.end.previousSibling) {
					endPos = ice.dom.getLastChild(this.end.previousSibling);
				} else {
					endPos = ice.dom.getFirstChild(this.end.nextSibling || this.end);
					endOffset = 0;
				}
			}

			ice.dom.remove([this.start, this.end]);
			try {
				ice.dom.normalize(parent);
			} 
			catch (e) {}

			if (endPos === null) {
				range.setEnd(startPos, startOffset);
				range.collapse(false);
			} 
			else {
				range.setStart(startPos, startOffset);
				if (endOffset === null) {
					endOffset = (endPos.length || 0);
				}
				range.setEnd(endPos, endOffset);
			}

			try {
				this.selection.addRange(range);
			} 
			catch (e) {
				// IE may throw exception for hidden elements..
			}
		},

		getBookmark: function(parent, type) {
			var elem = ice.dom.getClass('iceBookmark_' + type, parent)[0];
			return elem;
		},

		removeBookmarks: function(elem) {
			ice.dom.remove(ice.dom.getClass('iceBookmark', elem, 'span'));
		}
	};

	exports.Bookmark = Bookmark;

}).call(this.ice);/**
Copyright 2013 LoopIndex, This file is part of the Track Changes plugin for CKEditor.

The track changes plugin is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License, version 2, as published by the Free Software Foundation.
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
You should have received a copy of the GNU Lesser General Public License along with this program as the file lgpl.txt. If not, see http://www.gnu.org/licenses/lgpl.html.

Written by (David *)Frenkiel - https://github.com/imdfl

** Source Version **
**/
var LITE = {
	Events : {
		INIT : "lite:init",
		ACCEPT : "lite:accept",
		REJECT : "lite:reject",
		SHOW_HIDE : "lite:showHide",
		TRACKING : "lite:tracking",
		CHANGE: "lite:change"
	},
	
	Commands : {
		TOGGLE_TRACKING : "lite.ToggleTracking",
		TOGGLE_SHOW : "lite.ToggleShow",
		ACCEPT_ALL : "lite.AcceptAll",
		REJECT_ALL : "lite.RejectAll",
		ACCEPT_ONE : "lite.AcceptOne",
		REJECT_ONE : "lite.RejectOne",
		TOGGLE_TOOLTIPS: "lite.ToggleTooltips"
	}
};
