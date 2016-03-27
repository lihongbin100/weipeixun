package top.wexue.common.contoller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.bind.annotation.RequestMethod;
import top.wexue.utils.Constants;
import top.wexue.model.SessionInfo;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;


/**
 * 权限拦截器

 * 
 */
public class SecurityInterceptor implements HandlerInterceptor {


	private List<String> excludeUrls;// 不需要拦截的资源

	public List<String> getExcludeUrls() {
		return excludeUrls;
	}

	public void setExcludeUrls(List<String> excludeUrls) {
		this.excludeUrls = excludeUrls;
	}

	/**
	 * 完成页面的render后调用
	 */
	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object object, Exception exception) throws Exception {

	}

	/**
	 * 在调用controller具体方法后拦截
	 */
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object object, ModelAndView modelAndView) throws Exception {

	}

	/**
	 * 在调用controller具体方法前拦截
	 */
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object object) throws Exception {
		String requestUri = request.getRequestURI();
		String contextPath = request.getContextPath();
		String url = requestUri.substring(contextPath.length());
		// logger.info(url);

		if (excludeUrls.contains(url)) {// 如果要访问的资源是不需要验证的
			return true;
		}
		SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute(Constants.Config.SESSION_USER_NAME);
		if (sessionInfo == null || "".equalsIgnoreCase(sessionInfo.getId())) {// 如果没有登录或登录超时
			request.setAttribute("msg", "您还没有登录或登录已超时，请重新登录，然后再刷新本功能！");
			if( (RequestMethod.GET).equals(request.getMethod())){
				request.setAttribute("handlerUrl",requestUri);
			}
			request.getRequestDispatcher("/login").forward(request, response);
			return false;
		}
		return true;
	}
}
