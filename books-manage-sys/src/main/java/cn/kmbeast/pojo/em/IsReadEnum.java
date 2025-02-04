package cn.kmbeast.pojo.em;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum IsReadEnum {

    READ_OK(true, "已读"),
    READ_NO(false, "未读");

    /**
     * 是否已读
     */
    private final Boolean status;
    /**
     * 描述
     */
    private final String detail;

}
