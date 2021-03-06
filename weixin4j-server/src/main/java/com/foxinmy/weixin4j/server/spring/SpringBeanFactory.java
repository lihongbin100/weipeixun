//package com.foxinmy.weixin4j.server.spring;
//
//import java.util.Map;
//
//import org.springframework.context.ApplicationContext;
//
//import com.foxinmy.weixin4j.dispatcher.BeanFactory;
//import com.foxinmy.weixin4j.exception.WeixinException;
//
///**
// * 使用spring容器获取bean
// *
// * @className SpringBeanFactory
// * @author jy
// * @date 2015年8月11日
// * @since JDK 1.6
// * @see
// */
//public class SpringBeanFactory implements BeanFactory {
//
//	private ApplicationContext context;
//
//	public SpringBeanFactory(ApplicationContext context) {
//		this.context = context;
//	}
//
//	@Override
//	public Object getBean(String name) throws WeixinException {
//		return context.getBean(name);
//	}
//
//	@Override
//	public <T> T getBean(Class<T> classType) throws WeixinException {
//		return context.getBean(classType);
//	}
//
//	@Override
//	public <T> T getBean(String name, Class<T> classType) throws WeixinException {
//		return context.getBean(name, classType);
//	}
//
//	@Override
//	public <T> Map<String, T> getBeans(Class<T> clazz) throws WeixinException {
//		return context.getBeansOfType(clazz);
//	}
//}