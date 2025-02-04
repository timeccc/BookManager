package cn.kmbeast.pojo.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 书籍预定实体
 */
@Data
public class BookOrderHistory {
    /**
     * ID
     */
    private Integer id;
    /**
     * 书籍的ID
     */
    private Integer bookId;
    /**
     * 用户的ID
     */
    private Integer userId;
    /**
     * 借书的数量
     */
    private Integer deadlineNum;
    /**
     * 是否已经归还
     */
    private Boolean isReturn;
    /**
     * 归还的时间
     */
    private LocalDate returnTime;
    /**
     * 借书时间
     */
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;
}
