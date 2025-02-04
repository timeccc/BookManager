package cn.kmbeast.utils;

import java.util.UUID;

public class IdFactoryUtil {
    public static String getFileId() {
        return UUID.randomUUID().toString().substring(1, 8);
    }
}
