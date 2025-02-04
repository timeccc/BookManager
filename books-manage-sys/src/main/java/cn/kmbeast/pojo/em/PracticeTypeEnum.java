package cn.kmbeast.pojo.em;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 题型枚举
 */
@Getter
@AllArgsConstructor
public enum PracticeTypeEnum {

    ONE_SELECTED(1, "单选题"),
    DOUBLE_SELECTED(2, "多选题"),
    WORD_PUT(3, "填空题"),
    JUDGEMENT(4, "判断题");

    /**
     * 类型
     */
    private final Integer type;
    /**
     * 描述
     */
    private final String detail;

}
