package cn.kmbeast.pojo.em;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 禁言状态枚举
 */
@Getter
@AllArgsConstructor
public enum WordStatusEnum {

    USE(false, "可用"),
    BANK_USE(true, "禁言状态");

    /**
     * 状态
     */
    private final Boolean flag;
    /**
     * 名称
     */
    private final String name;

}
