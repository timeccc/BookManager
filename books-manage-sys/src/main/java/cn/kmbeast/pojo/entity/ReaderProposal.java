package cn.kmbeast.pojo.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * 读者建议
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class ReaderProposal {
    /**
     * 主键
     */
    private Integer id;
    /**
     * 用户ID
     */
    private Integer userId;
    /**
     * 建议
     */
    private String content;
    /**
     * 是否公开
     */
    private Boolean isPublish;
    /**
     * 回复内容
     */
    private String replyContent;
    /**
     * 是否已经回复
     */
    private Boolean isReply;
    /**
     * 回复时间
     */
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy年MM月dd日 HH:mm:ss")
    private LocalDateTime replyTime;
    /**
     * 反馈/建议时间
     */
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy年MM月dd日 HH:mm:ss")
    private LocalDateTime createTime;

}
