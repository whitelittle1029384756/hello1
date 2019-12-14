==================================== 第一题 ===============================
有50W个京东店铺，每个顾客访问任何一个店铺的任何一个商品时都会产生一条访问日志，
访问日志存储的表名为Visit，访客的用户id为user_id，被访问的店铺名称为shop，访问时间为visit_time。
数据样例：'huawei','1001','2017-02-10'，'apple','1001','2017-02-11'......
1）每个店铺的UV（访客数）
2）每个店铺访问次数top3的访客信息。输出店铺名称、访客id、访问次数

--建表
drop table if exists Visit;
create table test_two(
    shop string COMMENT '店铺名称',
    user_id string COMMENT '用户id',
    visit_time string COMMENT '访问时间'
)
row format delimited fields terminated by '\t';


--插入数据
insert into table Visit values ('huawei','1005','2017-02-10');
insert into table Visit values ('huawei','1005','2017-02-10');
insert into table Visit values ('huawei','1005','2017-02-10');
insert into table Visit values ('huawei','1005','2017-02-10');
insert into table Visit values ('huawei','1004','2017-02-10');
insert into table Visit values ('huawei','1004','2017-02-10');
insert into table Visit values ('huawei','1003','2017-02-10');
insert into table Visit values ('huawei','1003','2017-02-10');
insert into table Visit values ('huawei','1001','2017-02-10');
insert into table Visit values ('huawei','1002','2017-02-10');
insert into table Visit values ('huawei','1006','2017-02-10');
insert into table Visit values ('apple','1001','2017-02-10');
insert into table Visit values ('apple','1001','2017-02-10');
insert into table Visit values ('apple','1001','2017-02-10');
insert into table Visit values ('apple','1001','2017-02-10');
insert into table Visit values ('apple','1002','2017-02-10');
insert into table Visit values ('apple','1002','2017-02-10');
insert into table Visit values ('apple','1005','2017-02-10');
insert into table Visit values ('apple','1005','2017-02-10');
insert into table Visit values ('apple','1006','2017-02-10');
insert into table Visit values ('apple','1004','2017-02-10');
insert into table Visit values ('meizu','1006','2017-02-10');
insert into table Visit values ('meizu','1006','2017-02-10');
insert into table Visit values ('meizu','1006','2017-02-10');
insert into table Visit values ('meizu','1006','2017-02-10');
insert into table Visit values ('meizu','1003','2017-02-10');
insert into table Visit values ('meizu','1003','2017-02-10');
insert into table Visit values ('meizu','1003','2017-02-10');
insert into table Visit values ('meizu','1002','2017-02-10');
insert into table Visit values ('meizu','1002','2017-02-10');
insert into table Visit values ('meizu','1004','2017-02-10');


--1)每个店铺的UV（访客数）
select 
    shop,
    count(distinct(user_id)) shop_uv
from Visit
group by shop
order by shop_uv desc;

--或者

select
    shop,
    count(user_id) shop_uv
from
(
    select 
        shop,
        user_id
    from Visit
    group by shop,user_id
) t1
group by shop
order by shop_uv desc;


--2）每个店铺访问次数top3的访客信息。输出店铺名称、访客id、访问次数
select
    shop `商店名称`,
    user_id `用户id`,
    visit_num `访问次数`,
    rank_num `忠诚排名`
from
    (
    select
        shop,
        user_id,
        visit_num,
        row_number() over(partition by shop order by visit_num desc) rank_num
    from
    (
        select
            shop,
            user_id,
            count(*) visit_num
        from Visit
        group by shop,user_id
    ) t1
) t2
where rank_num<=3;

==================================== 第二题 ===============================
-- 已知一个表ORDER_TBL,有如下字段:Date,Order_id,User_id,amount。
-- 请给出sql进行统计:数据样例:2017-01-01,10029028,1000003251,33.57。
-- 1）给出 2017年每个月的订单数、用户数、总成交金额。
-- 2）给出2017年11月的新客数(指在11月才有第一笔订单)

drop table if exists ORDER_TBL;
create table ORDER_TBL
(
    `Date` String COMMENT '下单时间',
    `Order_id` String COMMENT '订单ID',
    `User_id` String COMMENT '用户ID',
    `amount` decimal(10,2) COMMENT '金额'
)
row format delimited fields terminated by '\t';

--插入数据
insert into table ORDER_TBL values ('2017-10-01','10029011','1000003251',19.50);
insert into table ORDER_TBL values ('2017-10-03','10029012','1000003251',29.50);
insert into table ORDER_TBL values ('2017-10-04','10029013','1000003252',39.50);
insert into table ORDER_TBL values ('2017-10-05','10029014','1000003253',49.50);
insert into table ORDER_TBL values ('2017-11-01','10029021','1000003251',130.50);
insert into table ORDER_TBL values ('2017-11-03','10029022','1000003251',230.50);
insert into table ORDER_TBL values ('2017-11-04','10029023','1000003252',330.50);
insert into table ORDER_TBL values ('2017-11-05','10029024','1000003253',430.50);
insert into table ORDER_TBL values ('2017-11-07','10029025','1000003254',530.50);
insert into table ORDER_TBL values ('2017-11-15','10029026','1000003255',630.50);
insert into table ORDER_TBL values ('2017-12-01','10029027','1000003252',112.50);
insert into table ORDER_TBL values ('2017-12-03','10029028','1000003251',212.50);
insert into table ORDER_TBL values ('2017-12-04','10029029','1000003253',312.50);
insert into table ORDER_TBL values ('2017-12-05','10029030','1000003252',412.50);
insert into table ORDER_TBL values ('2017-12-15','10029032','1000003255',612.50);

-- 1）给出 2017年每个月的订单数、用户数、总成交金额。

select
    date_format(`date`,'yyyy-MM') `date`,
    count(order_id) `订单数`,
    count(distinct(user_id)) `用户数`,
    sum(amount) `总成交金额`
from ORDER_TBL
group by date_format(`date`,'yyyy-MM');

-- 2）给出2017年11月的新客数(指在11月才有第一笔订单)
select
    t1.user_id
from
(
    select
        user_id
    from ORDER_TBL
    where date_format(`date`,'yyyy-MM') = '2017-11'
    group by user_id
) t1
left join
(
    select
        user_id
    from ORDER_TBL
    where date_format(`date`,'yyyy-MM') < '2017-11'
    group by user_id
) t2
on t1.user_id = t2.user_id
where t2.user_id is null;

-- 第二种写法
select
    count(User_id) `11月新客数`
from
(
    SELECT
        User_id,
        Order_id,
        `Date`,
        LAG (`DATE`,1,0) over(partition by User_id order by `Date`) preOrderDate
    FROM
        ORDER_TBL
) t1
where date_format(`date`,'yyyy-MM')='2017-11' and preOrderDate=0;