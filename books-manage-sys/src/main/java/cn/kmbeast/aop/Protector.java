package cn.kmbeast.aop;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 接口保护注解。
 * 该注解加在接口上，接口自动鉴权，并解析用户身份信息。
 * 符合用户身份的，才能使用具体接口功能。
 */
@Target({ElementType.PARAMETER, ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
public @interface Protector {
    /**
     * 角色名
     *
     * @return String
     */
    String role() default "";
}
