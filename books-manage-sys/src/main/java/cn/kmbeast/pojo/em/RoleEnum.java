package cn.kmbeast.pojo.em;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 用户角色枚举
 */
@Getter
@AllArgsConstructor
public enum RoleEnum {

    ADMIN(1, "管理员"),
    USER(2, "用户");

    /**
     * 角色编码
     */
    private final Integer role;
    /**
     * 角色名
     */
    private final String name;

    /**
     * 由角色编码获取角色名
     *
     * @param role 角色编码
     * @return String 角色名
     */
    public static String ROLE(Integer role) {
        for (RoleEnum value : RoleEnum.values()) {
            if (value.getRole().equals(role)) {
                return value.name;
            }
        }
        return null;
    }

}
