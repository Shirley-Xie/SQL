ANSI SQL:Structured Query Language 结构化查询语句
/*
DBMS
database,table, column,datatype, row(record), primary key
*/
table:Products
column:  prod_id     prod_price         prod_name             vend_id(供应商)  prod_desc
          BR01       5.9900           8 inch teddy bear           BRS01
          BR02       8.9900           12 inch teddy bear          BRS01 
          BR03       11.99             18 inch teddy bear         BRS01
          BNBG01     3.4900          Fish bean bag toy            DLL01
          BNBG02     3.4900           Bird bean bag toy           DLL01
          BNBG02     3.4900            Rabbit bean bag toy        DLL01
          RGAN01     4.9900            Raggedy Ann                DLL01
          RYL01      9.4900             King doll                 FNG01
          RYL02      4.9900             Queen doll                FNG01
table:Products
         prod_id		vend_id			 prod_name      prod_price  prod_desc
table:Vendors
         vend_id    vend_name    vend_address		vend_city   vend_state		vend_zip 	  vend_country 
table:Customers
         cust_id		cust_name    cust_address		cust_city		cust_state		cust_zip		cust_contact		cust_email
                   Kids Place                                                         Jim Jones              null
                  The Toy Store                                                       John Smith               null
table:Orders
				 order_num  order_date   cust_id
table:OrderItems
         order_num  order_item   prod_id        quantity    item_price

1. 检索数据 select 
  1.查询需要的列:SELECT prod_id, prod_name,prod_price FROM Products; (SQL关键字不区分大小写)
  2.查询所有列:  SELECT * FROM Products;(*:通配符代表所有)
  3.查询供应商ID不重名:
                  SELECT DISTINCT vend_id FROM Products; -- distinct:有区别的)
                  SELECT DISTINCT vend_id, prod_price FROM Products;-- prod_price一样才
  4.限制结果数量: SELECT TOP 5 prod_name FROM Products;  
    			 (DB2): SELECT prod_name FROM Products FETCH FIRST 5 ROWS ONLY;  
    		(Oracle): SELECT prod_name FROM Products WHERE ROWNUM <= 5  
    (MySQL,MariaDB, PostgreSQL,SQLite):
                  SELECT prod_name FROM Products LIMIT 2 OFFSET 5; 
                  -- 从第5行起的2个行数据,OFFSET不包含起始行，从0开始
    (MySQL,MariaDB快捷键):SELECT prod_name FROM Products LIMIT 2,5;

2. 排序检索数据 order by   
  1.按多个列排序:SELECT * FROM Products ORDER BY  prod_price, prod_name;
  2.按列位置排序:SELECT * FROM Products ORDER BY 2,3;--同上(按照*给的的顺序,混合使用:prod_price,1)
  3.指定排序方向:SELECT * FROM Products ORDER BY  prod_price DESC, prod_name;
                  --descending下降,默认 ASCending升序，默认Ad等价于a

3.过滤数据 where
  1.检索单个值: SELECT * FROM Products WHERE prod_price <> 3.49 ORDER BY prod_name; -- !=等价><
  2.范围值检查: SELECT * FROM Products WHERE prod_price BETWEEN 5 AND 10;-- 包含开始值和结束值 
  3.空值检查:   SELECT cust_name FROM Customers WHERE cust_email IS NULL;  

4.高级数据过滤 not in  
  1.多条过滤:     SELECT * FROM Products WHERE vend_id ='DLL01' AND prod_price <= 4; --AND操作符
  2.OR任意匹配:   SELECT prod_name, prod_price FROM Products WHERE vend_id ='DLL01' OR vend_id = 'BRS01';
  3.混合使用：    SELECT * FROM Products WHERE (vend_id ='DLL01' OR vend_id = 'BRS01') AND prod_price <= 10;--AND优先于OR
  4.IN的使用：    SELECT * FROM Products WHERE vend_id IN('DLL01','BRS01') ORDER BY prod_name; --or等价于in
  5.not的使用：   SELECT * FROM Products WHERE NOT prod_price = 3.49 ORDER BY prod_name;

5.通配符过滤(wildcard,浪费时间，若有选择则不用)
  1.找bean bag:   SELECT * FROM Products WHERE prod_name LIKE '%bean bag%';
    (Access用*)  --%:任何字符串出现任意次数，可以是0个，是否区分大小写看配置，null例外。   ？？？去空格
  2._单个字符:    SELECT * FROM Products WHERE prod_name LIKE '__inch teddy bear'; --Access用?
  3.查找J或M开头：SELECT cust_contact FROM Customers WHERE cust_contact LIKE '[JM]%' ORDER BY cust_contact;
                 --[](Access,SQL Server)指定字符串匹配一个字符指定位置
            取反：SELECT cust_contact FROM Customers WHERE /*二选一NOT*/ cust_contact LIKE '[^JM]%' ORDER BY cust_contact;
                 --Access用!  通配符尽量不要放在搜素模式的开始处

6.创建计算字段 --不实际存在于数据库中，字段不叫列
  1.显示不同表中的列，拼接 SELECT RTRIM(vend_name) + '(' + RTRIM(vend_country) +')' FROM Vendors ORDER BY vend_name;
     -- +:Access,SQL Server. ||: DB2, Oracle, PostgreSQL, Open Office,SQLite. RTRIM()去右边空格，LTRIM()左边，TRIM()两边.
  2.不同表结合用大写显示
  3.                 