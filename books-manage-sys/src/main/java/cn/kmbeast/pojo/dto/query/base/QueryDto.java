package cn.kmbeast.pojo.dto.query.base;

import lombok.*;

import java.time.LocalDateTime;

/**
 * 查询参数接收实体类基类，含有四项基础参数，使用时可以拓展
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
@Builder
public class QueryDto {
    /**
     * ID
     */
    private Integer id;
    /**
     * 当前页
     */
    private Integer current;
    /**
     * 页面数据大小
     */
    private Integer size;
    /**
     * 开始时间
     */
    private LocalDateTime startTime;
    /**
     * 结束时间
     */
    private LocalDateTime endTime;
}

