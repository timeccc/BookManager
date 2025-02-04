package cn.kmbeast.aop;

import cn.kmbeast.context.LocalThreadHolder;
import cn.kmbeast.pojo.api.ApiResult;
import cn.kmbeast.pojo.em.RoleEnum;
import cn.kmbeast.service.UserService;
import cn.kmbeast.utils.JwtUtil;
import io.jsonwebtoken.Claims;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.Objects;

/**
 * 接口鉴权保护切面
 */
@Aspect
@Component
public class ProtectorAspect {

    /**
     * 环绕通知
     * 执行前 --- （目标操作） ---执行后
     * 环绕：两端拦截
     *
     * @param proceedingJoinPoint 连接点
     * @return Object
     * @author 【B站：程序员晨星】
     */
    @Around("@annotation(cn.kmbeast.aop.Protector)")
    public Object auth(ProceedingJoinPoint proceedingJoinPoint) throws Throwable {
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        HttpServletRequest request = attributes.getRequest();
        String token = request.getHeader("token");
        if (token == null) {
            return ApiResult.error("身份认证失败，请先登录");
        }
        Claims claims = JwtUtil.fromToken(token);
        if (claims == null) {
            return ApiResult.error("身份认证失败，请先登录");
        }
        Integer userId = claims.get("id", Integer.class);
        Integer roleId = claims.get("role", Integer.class);
        // 获取被拦截方法的签名
        MethodSignature signature = (MethodSignature) proceedingJoinPoint.getSignature();
        // 获取方法上的@Protector注解实例
        Protector protectorAnnotation = signature.getMethod().getAnnotation(Protector.class);
        if (protectorAnnotation == null) {
            return ApiResult.error("身份认证失败，请先登录");
        }
        String role = protectorAnnotation.role();
        // 验证用户角色
        if (!"".equals(role)) {
            if (!Objects.equals(RoleEnum.ROLE(Math.toIntExact(roleId)), role)) {
                return ApiResult.error("无操作权限");
            }
        }
        // 放在 ThreadLocal里面，当前线程都可用
        LocalThreadHolder.setUserId(userId, roleId);
        Object result = proceedingJoinPoint.proceed();
        // 请求结束，释放资源
        LocalThreadHolder.clear();
        return result;
    }


}
