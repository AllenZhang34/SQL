/*窗口函数也称为OLAP函数。OLAP是online analytical processing的简称，意思是对数据库数据进行实时分析处理。 

适用范围:
(1)组内排名问题(排名问题,各部门按业绩排名;topN问题)
(2)同时具有分组和排序功能(先分组后排名)
(3)不减少原表行数
(4)语法如下:

‹窗口函数› over (partition by ‹用于分组的列名› 对表分组

order by ‹用于排序的列名›) 对分组结果排序

‹窗口函数› :专用窗口函数(rank,dense_rank,row_number等)

聚合函数:sum,avg,count,max,min等

窗口函数是对where 或group by子句处理后的结果进行操作.原则上只能写在select子句中

partition子句可省略,即不指定分组
*/

/*实例*/
--统计出每一个各户的所有订单并按每一个客户下的订单的金额 升序排序，同时给每一个客户的订单进行编号。这样就知道每个客户下几单了
select ROW_NUMBER() over(partition by customerID  order by totalPrice) as rows,customerID,totalPrice, DID from OP_Order

--统计每一个客户最近下的订单是第几次下的订单。
 with tabs as
(
select ROW_NUMBER() over(partition by customerID  order by totalPrice) as rows,customerID,totalPrice, DID from OP_Order
 )
select MAX(rows) as '下单次数',customerID from tabs group by customerID

--找出每一组中序号为一的数据
select * from(select id,name,age,salary,row_number()over(partition by id order by salary desc) rank
from TEST_ROW_NUMBER_OVER t)
where rank <2

--在使用 row_number() over()函数时候，over()里头的分组以及排序的执行晚于 where 、group by、  order by 的执行。
--排序找出年龄在13岁到16岁数据，按salary排序

select id,name,age,salary,row_number()over(order by salary desc)  rank
from TEST_ROW_NUMBER_OVER t where age between '13' and '16'
--结果：结果中 rank 的序号，其实就表明了 over(order by salary desc) 是在where age between and 后执行的

select vote.* FROM "sap.ino.db.idea::t_vote" as vote WHERE vote.id in (SELECT id from (SELECT id,
row_number() over(partition by idea_id,
user_id order by id desc) as RT
FROM "sap.ino.db.idea::t_vote")
WHERE RT > 1
)
order by vote.changed_at des
