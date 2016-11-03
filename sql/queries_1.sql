/*select count(*) from baidu_apps;


select * from logs where method_name = 'download_apps_from_board';*/

select context, backtrace from logs where level = 'error' and method_name = 'save_versions';


select * from logs where level = 'error' and method_name = 'save_versions' limit 1;

select created_at from logs order by created_at DESC limit 1; /* "2016-10-05 10:31:47.932314" */ /* "2016-10-05 20:01:13.368602" */

select count(*) from baidu_apps; /*10521*/ /* 10643 */

select * from logs where /*level = 'error'*/ /*and method_name = 'save_versions'*/ /*and*/ created_at >= '2016-10-05 20:01:13.368602'::timestamp;


select * 
from logs 
where created_at >= '2016-10-05 20:01:13.368602'::timestamp
	and message = 'itemdata has no app info'
;

select * 
from logs 
where created_at >= '2016-10-05 20:01:13.368602'::timestamp
	and message = 'itemdata has no app info'
;

SELECT (doc->'datatype') doc
FROM  (
   SELECT context::jsonb AS j FROM logs
   ) t
   , jsonb_array_elements(t.j) WITH ORDINALITY t1(doc, rn)
ORDER  BY doc->'s', rn;


/* 40, 606, 22, 354 */
select distinct (logs.context->'datatype')::text
from logs 
where created_at >= '2016-10-05 20:01:13.368602'::timestamp
	and message = 'itemdata has no app info'

; 

select *
from logs 
where (context->'datatype')::text IN ('40', '606', '22', '354')

; 

select * from baidu_ranks; /* "soft_common" */

select a.sname, r.* 
from baidu_ranks r
join baidu_apps a on a.id = r.app_id  
;

select rank_number, count(*)
from baidu_ranks
group by rank_number
order by count(*) desc;

select * from logs where message != 'app already saved';