class OrderProposals < ActiveRecord::Migration
  def change
    execute 'CREATE OR REPLACE FUNCTION idx(anyarray, anyelement)
  RETURNS INT AS
$$
  SELECT i FROM (
     SELECT generate_series(array_lower($1,1),array_upper($1,1))
  ) g(i)
  WHERE $1[i] = $2
  LIMIT 1;
$$ LANGUAGE SQL IMMUTABLE;'
  end
end
