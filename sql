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
          BNBG03     3.4900            Rabbit bean bag toy        DLL01
          RGAN01     4.9900            Raggedy Ann                DLL01
          RYL01      9.4900             King doll                 FNG01
          RYL02      4.9900             Queen doll                FNG01
table:Products
         prod_id		vend_id			 prod_name      prod_price  prod_desc
                    BRS01
                    BRS01
                    BRS01
                    DLL01
                    DLL01
                    DLL01
                    DLL01
                    FNG01
                    FNG01
table:Vendors
         vend_id    vend_name    vend_address		vend_city   vend_state		vend_zip 	  vend_country 
                  Bear Emporium
                  Bears R Us 
                  Doll House Inc.
                  Fun and Games
                  Furball Inc.
                  Jouets et ours 
table:Customers
         cust_id		cust_name    cust_address		cust_city		cust_state		cust_zip		cust_contact		cust_email
                   Kids Place                                   OH                    Jim Jones              null
                  The Toy Store                                 IL                    John Smith             null
                                                                                      Michael Green
                  Fun4All                                       IN        
                  Fun4All                                       AZ
                  Village Toys                                  MI                       
table:Orders
				 order_num  order_date   cust_id
                                 1000000001
         20005                   1000000002
         20006                   1000000003
         20007                   1000000004
         20008                   1000000005
         20009

table:OrderItems
         order_num  order_item   prod_id        quantity    item_price
          20007                  RGAN01
          20008                  RGAN01             5         4.9900    
          20008                  BR03               5         11.990
          20008                  BNBG01            10          3.4900
          20008                  BNBG02            10          3.4900
          20008                  BNBG03            10          3.4900
          20005


1. 检索数据 select 
  1. 查询需要的列:SELECT prod_id, prod_name,prod_price FROM Products; (SQL关键字不区分大小写)
  2. 查询所有列:  SELECT * FROM Products;(*:通配符代表所有)
  3. 查询供应商ID不重名:
                  SELECT DISTINCT vend_id FROM Products; -- distinct:有区别的)
                  SELECT DISTINCT vend_id, prod_price FROM Products;-- prod_price一样才
  4. 限制结果数量:SELECT TOP 5 prod_name FROM Products;  
    			 (DB2): SELECT prod_name FROM Products FETCH FIRST 5 ROWS ONLY;  
    		(Oracle): SELECT prod_name FROM Products WHERE ROWNUM <= 5  
    (MySQL,MariaDB, PostgreSQL,SQLite):
                  SELECT prod_name FROM Products LIMIT 2 OFFSET 5; 
                  -- 从第5行起的2个行数据,OFFSET不包含起始行，从0开始
    (MySQL,MariaDB快捷键):SELECT prod_name FROM Products LIMIT 2,5;

2. 排序检索数据 order by   
  1. 按多个列排序:SELECT * FROM Products ORDER BY  prod_price, prod_name;
  2. 按列位置排序:SELECT * FROM Products ORDER BY 2,3;--同上(按照*给的的顺序,混合使用:prod_price,1)
  3. 指定排序方向:SELECT * FROM Products ORDER BY  prod_price DESC, prod_name;
                  --descending下降,默认 ASCending升序，默认Ad等价于a

3. 过滤数据 where 过滤的是行过滤，分组前
  1. 检索单个值: SELECT * FROM Products WHERE prod_price <> 3.49 ORDER BY prod_name; -- !=等价><
  2. 范围值检查: SELECT * FROM Products WHERE prod_price BETWEEN 5 AND 10;-- 包含开始值和结束值 
  3. 空值检查:   SELECT cust_name FROM Customers WHERE cust_email IS NULL;  

4. 高级数据过滤 not in  
  1. 多条过滤:     SELECT * FROM Products WHERE vend_id ='DLL01' AND prod_price <= 4; --AND操作符
  2. OR任意匹配:   SELECT prod_name, prod_price FROM Products WHERE vend_id ='DLL01' OR vend_id = 'BRS01';
  3. 混合使用：    SELECT * FROM Products WHERE (vend_id ='DLL01' OR vend_id = 'BRS01') AND prod_price <= 10;--AND优先于OR
  4. IN的使用：    SELECT * FROM Products WHERE vend_id IN('DLL01','BRS01') ORDER BY prod_name; --or等价于in
  5. not的使用：   SELECT * FROM Products WHERE NOT prod_price = 3.49 ORDER BY prod_name;

5. 通配符过滤(wildcard,浪费时间，若有选择则不用)
  1. 找bean bag:   SELECT * FROM Products WHERE prod_name LIKE '%bean bag%';
    (Access用*)  --%:任何字符串出现任意次数，可以是0个，是否区分大小写看配置，null例外。   ？？？去空格
  2. _单个字符:    SELECT * FROM Products WHERE prod_name LIKE '__inch teddy bear'; --Access用?
  3. 查找J或M开头：SELECT cust_contact FROM Customers WHERE cust_contact LIKE '[JM]%' ORDER BY cust_contact;
                 --[](Access,SQL Server)指定字符串匹配一个字符指定位置
             取反：SELECT cust_contact FROM Customers WHERE /*二选一NOT*/ cust_contact LIKE '[^JM]%' ORDER BY cust_contact;
                 --Access用!  通配符尽量不要放在搜素模式的开始处

6. 创建计算字段 --不实际存在于数据库中，字段不叫列
  1.显示不同表中的列，可以使用别名AS，拼接：
              SELECT RTRIM(vend_name) + '(' + RTRIM(vend_country) +')' AS vend_title FROM Vendors ORDER BY vend_name;
              -- +:Access,SQL Server. ||: DB2, Oracle, PostgreSQL, Open Office,SQLite. 
  2.获取总价：SELECT prod_id, quantity, item_price, quantity*item_price AS expanded_price FROM OrderItems WHERE order_num = 20008;

7. 使用数据处理函数
  1.文本处理：SELECT vend_name, UPPER(vend_name) AS vend_name_upcase FROM Vendors ORDER BY vend_name;
    --LEFT()返回字符串左边的字符，RIGHT()右边                --LENGTH()/DATALENGTH()/LEN()返回字符串的长度
    --LOWER()小写 Access:LCASE()                             --RTRIM()去掉右边空格，LTRIM()左边，TRIM()两边
    --SOUNDEX() 返回字符串发音相似值Access,PostgreSQL不支持  --UPPER()大写，Access:UCASE() 
              SELECT cust_name, cust_contact FROM Customers WHERE SOUNDEX(cust_contact) = SOUNDEX('Michael Green')
  2. 时间处理,检索2012年所有订单：
              SELECT order_num FROM Orders WHERE DATEPART(yy, order_date) = 2012;
              --Access 'yyyy' --PostgreSQL: DATE_PART 'year'
              /*Oracle Where to_number(to_char(order_date,'YYYY'))或 
               WHERE order_date BETWEEN to_date('01-01-2012')AND to_date('12-31-2012')
              */
              --MySQL MariaDB：WHERE YEAR(order_date) = 2012
              --SQLite WHERE strftime('%Y', order_date) = 2012
  3. 最统一的数值处理：   
              --ABS() COS() EXP() PI() SIN() SQRT()平方根 TAN()

8. 汇总数据(聚集函数) --AVG(),COUNT(),MAX(),MIN(),SUM()
  1. AVG():    SELECT AVG(prod_price) AS avg_price FROM Products WHERE vend_id = 'DLL01';
  2. COUNT():  SELECT COUNT(cust_email) AS num_cust FROM Customers;--若为指定怎null不计数，若*则null计数。
  3. MAX():    SELECT MAX(prod_price) AS max_price FROM Products;--若为文本内容返回排序后的最后一行。
  4. MIN():    SELECT MIN(prod_price) AS max_price FROM Products;
  5. SUM():    SELECT SUM(item_price*quantity) AS total_price FROM OrderItems WHERE order_num = 20005;
  6. 聚集不同函数：--DISTINCT ALL 不适用Access 
              SELECT COUNT(*) AS num_items, MIN(prod_price) AS price_min, MAX(prod_price) AS prod_max,
                     AVG(prod_price) AS price_avg FROM Products;

9. 分组数据：GROUP BY ,HAVING，ORDER BY 分组后过滤
  1.           SELECT vend_id, COUNT(*) AS num_prods FROM Products GROUP BY vend_id;
  2. 过滤分组排序，订单超过2次的客户,按照数量和cust_id排序：
               SELECT cust_id, COUNT(*) AS orders FROM Orders GROUP BY cust_id HAVING COUNT(*) >= 2 ORDER BY orders, cust_id;
               -- Access 不按别名排序    
  3. 订单超过2次的客户且价格大于4：
               SELECT vent_id, COUNT(*) AS num_prods FROM Products  WHERE prod_price >= 4 GROUP BY vent_id HAVING COUNT(*) >= 2;
  4. SELECT 顺序 *FROM**WHERE***GROUP BY****HAVING*****ORDER BY 

10. 子查询：只能查询单列
      查找订单物品RGAN01的所有客户--从OrderItems (order_num) Orders (cust_id) Customers
   1. Child = SELECT cust_id FROM Orders WHERE order_num IN (SELECT order_num FROM OrderItems WHERE prod_id = 'RGAN01')
      SELECT cust_name, cust_contact FROM Customers WHERE cust_id IN(Child);--太长写2个
   2. 作为计算字段
      Child = SELECT COUNT(*) FROM Orders WHERE Orders.cust_id = Customers.cust_id;
   3. SELECT cust_name, cust_state, Child AS orders FROM Customers ORDER BY cust_name;

11. 联结表
   1. 联结       SELECT vend_name, prod_name, prod_price FROM Vendors, Products WHERE Vendors.vend_id = Products.vend_id;

   2. 内联结     SELECT vend_name, prod_name, prod_price FROM Vendors INNER JOIN Products ON Vendors.vend_id = Products.vend_id; 

   3. 联结多个表 SELECT prod_name, vend_name, prod_price, quantity FROM OrderItems, Products, Vendors WHERE Products.vend_id = Vendors.vend_id
                 AND OrderItems.prod_id = Products.prod_id AND order_num = 20007;

    10.1 的等价  SELECT cust_name, cust_contact FROM Customers, Orders, OrderItems WHERE Customers.cust_id = Orders.cust_id
                 AND OrderItems.order_num = Orders.order AND prod_id = 'RGAN01';



12. 创建高级联结
  1. 使用表别名 SELECT RTRIM(vend_name) + '(' + RTRIM(vend_country) + ')' AS vend_title FROM Vendors ORDER BY vend_name;

                SELECT cust_name, cust_contact FROM Customers AS C, Orders AS O, OrderItems AS OI WHERE C.cust_id = O.cust_id
                AND OI.order_num = O.order_num  AND prod_id = 'RGAN01';

  2. 自联结:排除多次出现  -- 给jim jones 同一公司的所有顾客发信息 方案一子查询 方案二联结
                SELECT c1.cust_id, c1.cust_name, c1.cust_contact FROM Customers AS c1, Customers AS c2 WHERE c1.cust_name = c2.cust_name 
                AND c2.cust_contact = 'Jim Jones'; 
                SELECT C.*, O.order_num, O.order_date, OI.prod_id, OI.quantity, OI.item_price FROM Customers AS C,Orders AS O, 
                OrderItems AS OI WHERE C.cust_id = O.cust_id AND OI.order_num = O.order_num  AND prod_id = 'RGAN01';  

  3. 外联结：相关表中没有没有关联行的行
             ~对每个客户下的订单进行计数，包括那些至今尚未下单的客户   
             ~列出所有产品以及订购数量的产品，包括没人订购的产品
             ~计算平均销售规模，包括那些尚未下单尚未顾客

             SELECT Customers.cust_id, Orders.order_num FROM Customers INNER JOIN Orders ON Customers.cust_id = Orders.cust_id;--内联结
             SELECT Customers.cust_id, Orders.order_num FROM Customers LEFT OUTER JOIN Orders  ON Customers.cust_id = Orders.cust_id;--外联结
             --SQLite 支持 LEFT 不支持 RIGHT 全外联结：
             SELECT Customers.cust_id, Orders.order_num FROM Orders FULL OUTER JOIN Customers ON Customers.cust_id = Orders.cust_id; 
             --Access,MariaDB,MySQL,Open Office Base 或 SQLite 不支持FULL

  4. 带聚集函数：(SELECT Customers.cust_id, COUNT(Orders.order_num) AS num_ord FROM Customers INNER JOIN Orders ON Customers.cust_id = 
                 Orders.cust_id GROUP BY  Customers.cust_id;)
                 SELECT Customers.cust_id, COUNT(Orders.order_num) AS num_ord FROM Customers LEFT OUTER JOIN Orders ON Customers.cust_id = 
                 Orders.cust_id GROUP BY  Customers.cust_id; --1000000002 0

  
13. 组合查询
            在一个查询中从不同的表返回结构数据
            对一个表执行多个查询，按一个查询返回数据

    1. 使用UNION: SELECT cust_name, cust_contact, cust_email FROM Customers WHERE cust_state IN ('IL','IN','MI') 
                  UNION SELECT cust_name, cust_contact, cust_email FROM Customers WHERE cust_name = 'Fun4All';
                  --联结多个SELECT

14. 插入数据
   1. 全行插入：  INSERT INTO Customers VALUES('100000006', 'Toy Land', '123', 'NEW York', '11111', 'USA', 'NULL','NULL'); --还可以写对应的
   2. 插入部分行：INSERT INTO Customers(cust_id, cust_name) VALUES('100000006', 'Toy Land');   
   3. 插入检索出的数据：
                  INSERT INTO Customers(cust_id, cust_name) SELECT cust_id, cust_name FROM CustNew;--插入所有
   4. 从一个表复制到另一个表：SELECT INTO --DB2不支持
                  SELECT * INTO CustCopy FROM Customers;
                  --MariaDB, MySQL, Oracle, PostgreSQL, SQLite不同
                  CREATE TABLE CustCopy AS SELECT * FROM Customers;

15. 更新和删除数据
                  
                                             





   







