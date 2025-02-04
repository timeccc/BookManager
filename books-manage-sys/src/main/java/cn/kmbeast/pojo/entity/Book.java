package cn.kmbeast.pojo.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class Book {
    /**
     * 主键
     */
    private Integer id;
    /**
     * 书籍名
     */
    private String name;
    /**
     * 书籍封面
     */
    private String cover;
    /**
     * 出版商
     */
    private String publisher;
    /**
     * 作者
     */
    private String author;
    /**
     * 国际标准书号
     */
    private String isbn;
    /**
     * 馆藏数量
     */
    private Integer num;
    /**
     * 书籍的简介
     */
    private String detail;
    /**
     * 书架ID
     */
    private Integer bookShelfId;
    /**
     * 书籍类别ID
     */
    private Integer categoryId;
    /**
     * 是否计划购买 (0:false,1:true)
     */
    private Boolean isPlanBuy;
    /**
     * 购买时间
     */
    private LocalDate planBuyTime;
    /**
     * 入库时间
     */
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;
}
