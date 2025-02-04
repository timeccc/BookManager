package cn.kmbeast.pojo.dto.query.extend;

import cn.kmbeast.pojo.dto.query.base.QueryDto;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
public class BookOrderHistoryQueryDto extends QueryDto {
    private Integer userId;
    private Integer bookId;
    private Boolean isReturn;
}
