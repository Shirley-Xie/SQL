date_format：
本年："SELECT * FROM `t_node_info` where status = 1 AND type = ? AND date_format(update_time,'%Y') = date_format(now(),'%Y')" ;break;
本月："SELECT * FROM `t_node_info` where status = 1 AND type = ? AND date_format(update_time,'%Y-%m') = date_format(now(),'%Y-%m')";break;
本周： "SELECT * FROM `t_node_info` where status = 1 AND type = ? AND YEARWEEK(date_format(update_time,'%Y-%m-%d')) = YEARWEEK(now())";break;
#生成当前的空间的入驻节点sql
SELECT GROUP_CONCAT
   (
	CONCAT("INSERT INTO t_node_info (id,pid,NAME,TYPE,STATUS,create_time,update_time,sort)
		VALUES('",CONCAT('2',t.id),"','",t.id ,"','申请入驻',7,1,'20170504150558','20170504150558',992)"
	)SEPARATOR ';'
	)
FROM t_node_info t WHERE t.type=-5 AND t.status=1

Sample table : book_mast
+---------+-------------------------------------+-------------+---------+--------+--------+------------+----------+---------+------------+
| book_id | book_name                           | isbn_no     | cate_id | aut_id | pub_id | dt_of_pub  | pub_lang | no_page | book_price |
+---------+-------------------------------------+-------------+---------+--------+--------+------------+----------+---------+------------+
| BK001   | Introduction to Electrodynamics     | 0000979001  | CA001   | AUT001 | P003   | 2001-05-08 | English  |     201 |      85.00 |
| BK002   | Understanding of Steel Construction | 0000979002  | CA002   | AUT002 | P001   | 2003-07-15 | English  |     300 |     105.50 |
| BK003   | Guide to Networking                 | 0000979003  | CA003   | AUT003 | P002   | 2002-09-10 | Hindi    |     510 |     200.00 |
| BK004   | Transfer  of Heat and Mass          | 0000979004  | CA002   | AUT004 | P004   | 2004-02-16 | English  |     600 |     250.00 |
| BK005   | Conceptual Physics                  | 0000979005  | CA001   | AUT005 | P006   | 2003-07-16 | NULL     |     345 |     145.00 |
| BK006   | Fundamentals of Heat                | 0000979006  | CA001   | AUT006 | P005   | 2003-08-10 | German   |     247 |     112.00 |
| BK007   | Advanced 3d Graphics                | 0000979007  | CA003   | AUT007 | P002   | 2004-02-16 | Hindi    |     165 |      56.00 |
| BK008   | Human Anatomy                       | 0000979008  | CA005   | AUT008 | P006   | 2001-05-17 | German   |      88 |      50.50 |
| BK009   | Mental Health Nursing               | 0000979009  | CA005   | AUT009 | P007   | 2004-02-10 | English  |     350 |     145.00 |
| BK010   | Fundamentals of Thermodynamics      | 0000979010  | CA002   | AUT010 | P007   | 2002-10-14 | English  |     400 |     225.00 |
| BK011   | The Experimental Analysis of Cat    | 0000979011  | CA004   | AUT011 | P005   | 2007-06-09 | French   |     225 |      95.00 |
| BK012   | The Nature  of World                | 0000979012  | CA004   | AUT005 | P008   | 2005-12-20 | English  |     350 |      88.00 |
| BK013   | Environment a Sustainable Future    | 0000979013  | CA004   | AUT012 | P001   | 2003-10-27 | German   |     165 |     100.00 |
| BK014   | Concepts in Health                  | 0000979014  | CA005   | AUT013 | P004   | 2001-08-25 | NULL     |     320 |     180.00 |
| BK015   | Anatomy & Physiology                | 0000979015  | CA005   | AUT014 | P008   | 2000-10-10 | Hindi    |     225 |     135.00 |
| BK016   | Networks and Telecommunications     | 00009790_16 | CA003   | AUT015 | P003   | 2002-01-01 | French   |      95 |      45.00 |
+---------+-------------------------------------+-------------+---------+--------+--------+------------+----------+---------+------------+
1. MySQL GROUP_CONCAT() 
语句：实现cate_id根据pub_id站队
mysql> SELECT pub_id,GROUP_CONCAT(cate_id) --跟班的
    -> FROM book_mast
    -> GROUP BY pub_id; --领导的

返回结果：（默认逗号分隔）    
+--------+-----------------------+
| pub_id | GROUP_CONCAT(cate_id) |
+--------+-----------------------+
| P001   | CA002,CA004           | 
| P002   | CA003,CA003           | 
| P003   | CA001,CA003           | 
| P004   | CA005,CA002           | 
| P005   | CA001,CA004           | 
| P006   | CA005,CA001           | 
| P007   | CA005,CA002           | 
| P008   | CA005,CA004           | 
+--------+-----------------------+

2.MySQL GROUP_CONCAT() with order by and distinct
语句：实现cate_id根据pub_id站队 --DISTINCT：消重，看结果的第四行CA003，只有一个。ASC：升序
mysql> SELECT pub_id,GROUP_CONCAT(DISTINCT cate_id)
    -> FROM book_mast 
    -> GROUP BY pub_id
    -> ORDER BY GROUP_CONCAT(DISTINCT cate_id) ASC;
返回结果：
+--------+--------------------------------+
| pub_id | GROUP_CONCAT(DISTINCT cate_id) |
+--------+--------------------------------+
| P003   | CA001,CA003                    | 
| P005   | CA001,CA004                    | 
| P001   | CA002,CA004                    | 
| P002   | CA003                          | 
| P006   | CA005,CA001                    | 
| P004   | CA005,CA002                    | 
| P007   | CA005,CA002                    | 
| P008   | CA005,CA004                    | 
+--------+--------------------------------

3. MySQL GROUP_CONCAT() with separator
语句：
mysql> SELECT pub_id,GROUP_CONCAT(DISTINCT cate_id
    -> ORDER BY  cate_id ASC SEPARATOR ' ')
    -> FROM book_mast
    -> GROUP BY pub_id ;
+--------+----------------
返回结果：
+--------+--------------------------------------------------------------------+
| pub_id | GROUP_CONCAT(DISTINCT cate_id ORDER BY  cate_id ASC SEPARATOR ' ') |
+--------+--------------------------------------------------------------------+
| P001   | CA002 CA004                                                        | 
| P002   | CA003                                                              | 
| P003   | CA001 CA003                                                        | 
| P004   | CA002 CA005                                                        | 
| P005   | CA001 CA004                                                        | 
| P006   | CA001 CA005                                                        | 
| P007   | CA002 CA005                                                        | 
| P008   | CA004 CA005                                                        | 
+--------+--------------------------------------------------------------------+

参考文章：http://www.w3resource.com/mysql/aggregate-functions-and-grouping/aggregate-functions-and-grouping-group_concat.php#