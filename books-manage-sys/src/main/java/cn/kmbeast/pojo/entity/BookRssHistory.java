package cn.kmbeast.pojo.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 图书订阅实体
 */
@Data
public class BookRssHistory {
    /**
     * 主键
     */
    private Integer id;
    /**
     * 书籍ID
     */
    private Integer bookId;
    /**
     * 用户ID
     */
    private Integer userId;
    /**
     * 订阅时间
     */
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;
}
