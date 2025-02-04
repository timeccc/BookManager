package cn.kmbeast.pojo.api;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

/**
 * 通用响应 - 分页
 *
 * @param <T> 泛型
 * @author 【B站：程序员晨星】
 */
@EqualsAndHashCode(callSuper = true)
@AllArgsConstructor
@NoArgsConstructor
@Data
public class PageResult<T> extends Result<T> {

    /**
     * 分页响应数据
     */
    private T data;
    /**
     * 符合条件的总记录数
     */
    private Integer total;

    /**
     * 参数构造
     *
     * @param code 响应码
     * @author 【B站：程序员晨星】
     */
    public PageResult(Integer code) {
        super(code, "查询成功");
    }

    /**
     * 分页查血结果反馈
     *
     * @param data  数据源
     * @param total 总记录数
     * @param <T>   泛型
     * @return <T>
     * @author 【B站：程序员晨星】
     */
    public static <T> Result<T> success(T data, Integer total) {
        PageResult<T> result = new PageResult<>(ResultCode.REQUEST_SUCCESS.getCode());
        result.setData(data);
        result.setTotal(total);
        return result;
    }

}
