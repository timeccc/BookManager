package cn.kmbeast.pojo.dto.query.extend;

import cn.kmbeast.pojo.dto.query.base.QueryDto;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 类别的查询条件类
 */
@Data
@EqualsAndHashCode(callSuper = true)
public class CategoryQueryDto extends QueryDto {

    /**
     * 类别名
     */
    private String name;

}
