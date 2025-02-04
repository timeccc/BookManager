package cn.kmbeast.pojo.dto.query.extend;

import cn.kmbeast.pojo.dto.query.base.QueryDto;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 用户行为基础查询类
 */
@EqualsAndHashCode(callSuper = true)
@Data
public class UserOperationLogQueryDto extends QueryDto {
    private Integer userId;
    private Boolean isRead;
    private String content;
}
