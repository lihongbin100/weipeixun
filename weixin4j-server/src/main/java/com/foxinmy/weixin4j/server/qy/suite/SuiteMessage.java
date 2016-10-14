package com.foxinmy.weixin4j.server.qy.suite;

import java.io.Serializable;
import java.util.Date;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;

/**
 * 套件消息
 * 
 * @className SuiteMessage
 * @author jy
 * @date 2015年6月23日
 * @since JDK 1.6
 * @see
 */
@XmlRootElement(name = "xml")
@XmlAccessorType(XmlAccessType.FIELD)
public class SuiteMessage implements Serializable {

	private static final long serialVersionUID = 6457919241019021514L;
	/**
	 * 应用套件的SuiteId
	 */
	@XmlElement(name = "SuiteId")
	private String suiteId;
	/**
	 * 事件类型
	 */
	@XmlElement(name = "InfoType")
	private String eventType;
	/**
	 * 时间戳
	 */
	@XmlElement(name = "TimeStamp")
	private long timeStamp;
	/**
	 * Ticket内容
	 */
	@XmlElement(name = "SuiteTicket")
	private String suiteTicket;
	/**
	 * 授权方企业号的corpid
	 */
	@XmlElement(name = "AuthCorpId")
	private String authCorpId;

	/**
	 * 授权的auth_code,用于获取企业的永久授权码 测试使用
	 */
	@XmlElement(name = "AuthCode")
	private String authCode;


	public String getSuiteId() {
		return suiteId;
	}

	public String getEventType() {
		return eventType;
	}

	@XmlTransient
	public SuiteEventType getFormatEventType() {
		return SuiteEventType.valueOf(eventType);
	}

	public long getTimeStamp() {
		return timeStamp;
	}

	@XmlTransient
	public Date getFormatTimeStamp() {
		return timeStamp > 0l ? new Date(timeStamp * 1000l) : null;
	}

	public String getSuiteTicket() {
		return suiteTicket;
	}

	public String getAuthCorpId() {
		return authCorpId;
	}

	public String getAuthCode() {
		return authCode;
	}

	@Override
	public String toString() {
		return "SuiteMessage [suiteId=" + suiteId + ", eventType="
				+ eventType + ", timeStamp=" + timeStamp + ", suiteTicket="
				+ suiteTicket + ", authCorpId=" + authCorpId + "]";
	}
}
