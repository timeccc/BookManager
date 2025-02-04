package cn.kmbeast.pojo.entity;

import lombok.Data;

/**
 * 书架实体
 */
@Data
public class BookShelf {
    /**
     * 主键
     */
    private Integer id;
    /**
     * 书架所在的楼层
     */
    private String floor;
    /**
     * 书架所处的区域
     */
    private String area;
    /**
     * 书架名
     */
    private String frame;
}
