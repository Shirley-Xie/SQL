date_format：
本年："SELECT * FROM `t_node_info` where status = 1 AND type = ? AND date_format(update_time,'%Y') = date_format(now(),'%Y')" ;break;
本月："SELECT * FROM `t_node_info` where status = 1 AND type = ? AND date_format(update_time,'%Y-%m') = date_format(now(),'%Y-%m')";break;
本周： "SELECT * FROM `t_node_info` where status = 1 AND type = ? AND YEARWEEK(date_format(update_time,'%Y-%m-%d')) = YEARWEEK(now())";break;
