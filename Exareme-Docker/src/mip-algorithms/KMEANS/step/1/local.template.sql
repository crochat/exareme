requirevars 'defaultDB' 'y';
attach database '%{defaultDB}' as defaultDB;

var 'x' '%{y}';

update defaultDB.algorithmparameters set val=val +1 where name ='iterations';

--Assign Data to Nearest Cluster
var 'distance' from select create_complex_query("","(?-?_clval)*(?-?_clval)","+","",'%{x}');
drop table if exists defaultDB.assignnearestcluster;
create table  defaultDB.assignnearestcluster as
select rid, clid, min(%{distance}) as mindist
from ( select * from defaultDB.localinputtbl join (select * from defaultDB.clustercenters_local))
group by rid;

var 'partialSums' from select create_complex_query("clid, count(clid) as clN,","sum(?) as ?_clS",",",'','%{x}');
drop table if exists defaultDB.partialclustercenters;
create table defaultDB.partialclustercenters as
select %{partialSums}
from  (select rid, %{x} from defaultDB.localinputtbl),
      (select rid as rid1, clid from assignnearestcluster)
where rid=rid1
group by clid;

select * from defaultDB.partialclustercenters;
