require 'cancan'

class Frm::ApplicationController < ApplicationController
  layout 'groups'

  before_filter :load_group



end
