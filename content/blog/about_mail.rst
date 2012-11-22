About Mail
===================

:date: 2009-03-19 11:03:06
:tags: Python

今天看了下python发送邮件是怎样使用的. 主要是可以利用python标准库中的smtplib, 首先列出一些资料:

* RFC 821: Simple Mail Transfer Protocol http://www.faqs.org/rfcs/rfc821.html
* RFC 1869: SMTP Service Extensions http://www.faqs.org/rfcs/rfc1869.html
* 标准库文档: smtplib http://docs.python.org/lib/module-smtplib.html
* PyMOTW: smtplib http://www.vbarter.cn/pymotw/documents/smtplib.html 暂时不可用
* django发送邮件: http://docs.djangoproject.com/en/dev/topics/email/

1) 使用SMTPServer的话, 可以类似如下的方式:

.. sourcecode:: python

    def _send_mail(username, email, mailtype, **args):
        import smtplib
        from email.utils import formataddr
        from email.mime.text import MIMEText
        import time
        from settings import EMAIL_HOST, EMAIL_HOST_USER, EMAIL_HOST_PASSWORD  # setting中设置
        #...
        msg = MIMEText(msg)                 # msg为一般纯文本
        msg['To'] = formataddr((username, email))
        msg['From'] = formataddr((EMAIL_HOST_USER, EMAIL_HOST_USER))
        msg['Subject'] = subject
        server = smtplib.SMTP(EMAIL_HOST)
        server.set_debuglevel(True)
        try:
            server.ehlo()                   # 验证, 如, 'smtp.gmail.com'需要处理认证和TLS(一种底层通讯的安全协议)加密。
            if server.has_extn('STARTTLS'):
                server.starttls()
                server.ehlo()
            server.login(EMAIL_HOST_USER, EMAIL_HOST_PASSWORD)
            server.sendmail(EMAIL_HOST_USER, [email], msg.as_string())  # 这种方法的话, msg中有html代码无法解析, MIMEText估计需要设置
            return True
        except:
            return False
        finally:
            server.quit()

2) 使用Django提供的

.. sourcecode:: python

    def _send_mail(username, email, mailtype, **args):
        import time
        #from django.core.mail import send_mail
        #from django.core.mail import EmailMultiAlternatives
        from django.core.mail import EmailMessage
        from settings import EMAIL_HOST_USER, QUQU_SITE_URL
        # ...
        try:
            #send_mail(subject, msg, EMAIL_HOST_USER,[email], fail_silently=False)  ## 直接使用send_mail
            #mm = EmailMultiAlternatives(subject, 'some text', EMAIL_HOST_USER,[email])
            #mm.attach_alternative(msg, "text/html")   ## 这个可以设置类型
            mm = EmailMessage(subject, msg, EMAIL_HOST_USER, [email])  ##这个最方便
            mm.content_subtype = "html"
            mm.send()
            return True
        except:
            return False

所以说django中发送邮件是最简单的,什么都帮你弄好了.　傻瓜式的用现成的就能发送邮件了....