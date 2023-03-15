-- 容器监控信息表(rqlite加 comment 备注会失败)
create table if not exists `test` (
    `id` INTEGER PRIMARY KEY AUTOINCREMENT,
    `name` VARCHAR(64) NOT NULL,
    `created_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);