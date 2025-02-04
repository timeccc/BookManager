package cn.kmbeast.aop;

import cn.kmbeast.context.LocalThreadHolder;
import cn.kmbeast.mapper.UserOperationLogMapper;
import cn.kmbeast.pojo.entity.UserOperationLog;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.annotation.Resource;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * 接口鉴权保护切面
 */
@Aspect
@Component
public class LogAspect {

    @Resource
    private UserOperationLogMapper userOperationLogMapper;

    /**
     * 环绕通知
     * 执行前 --- （目标操作） ---执行后
     * 环绕：两端拦截
     *
     * @param proceedingJoinPoint 连接点
     * @return Object
     * @author 【B站：程序员辰星】
     */
    @Around("@annotation(cn.kmbeast.aop.Log)")
    public Object auth(ProceedingJoinPoint proceedingJoinPoint) throws Throwable {
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        // 获取被拦截方法的签名
        MethodSignature signature = (MethodSignature) proceedingJoinPoint.getSignature();
        // 获取方法上的@Log注解实例
        Log logAnnotation = signature.getMethod().getAnnotation(Log.class);
        // 拿到注解里面的行为描述
        String content = logAnnotation.content();
        // 构造行为体，然后新增
        Integer userId = LocalThreadHolder.getUserId();
        LocalDateTime nowTime = LocalDateTime.now();
        Object proceed = proceedingJoinPoint.proceed();
        // 行为记录
        UserOperationLog userOperationLog = new UserOperationLog();
        userOperationLog.setUserId(userId).setContent(content).setCreateTime(nowTime);
        List<UserOperationLog> userOperationLogList = new ArrayList<>();
        userOperationLogList.add(userOperationLog);
        userOperationLogMapper.save(userOperationLogList);
        return proceed;
    }


}
