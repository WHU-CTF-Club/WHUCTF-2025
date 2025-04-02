import uuid
from hashlib import md5

from models import User, Notice

USERS = []
NOTICES = []
TOKENS = []

USERS.append(User("admin", md5(uuid.uuid4().hex.encode()).hexdigest()))

NOTICES.append(Notice("C语言面向对象禁令", "C-1972/NoOO", """
郑重警告：在malloc/free结界内擅自用结构体模拟对象属违法行为！凡被检测到用函数指针伪装多态者，将遭段错误精准打击。
互助会推荐疗法：每日背诵"我是无情的机器码奴隶，我没有对象"-1遍，并用宏定义浇灭一切类继承幻想。
<br/><br/>
—— 内存裸奔者互助会"""))

NOTICES.append(Notice("C++语法SM公约","Cpp-1985/S&M","""
即日起，模板偏特化、右值引用等语法被正式认证为疼痛美学工具包。开发者须佩戴三副语法枷锁，接受编译器皮鞭的抽打调试。凡在代码中同时出现四种以上抽象范式者，可领取"脑细胞死亡证明"电子勋章。
<br/><br/>
—— 痛苦阈值管理局"""))

NOTICES.append(Notice("Python之禅特别补充条款","Py-42号圣谕","""
为维护"人生苦短"的核心价值观，现永久冻结多线程性能优化计划。GIL全局解释器锁正式更名为"单线程交响乐团指挥棒"。凡妄图通过协程以外方式提升并发效率者，均视为对龟速美学的亵渎。
另严正声明：Python2已于2020年完成数字极乐往生，任何招魂行为将触发ImportError天罚。
<br/><br/>
—— 缩进教廷理事会"""))

NOTICES.append(Notice("Java就业危机预警", "JDK-1.8Eternal", """
鉴于全球培训机构已实现Java工程师量子克隆，现宣布所有"精通Spring/MyBatis"的简历将自动触发垃圾回收机制。凡求职者须通过八股文十级考试，并在简历标注"线程池参数背诵浓度"。
严正声明：若在招聘现场发现2147483647人以上高喊"面向对象三大特性"，将启动JVM内存溢出(OOM)保护程序。
<br/><br/>
—— 八股文量产委员会"""))

NOTICES.append(Notice("关于JavaScript类型系统的紧急公告","JS-2023-荒谬令", """
鉴于近期多位开发者在加法运算中产生认知混乱，本委员会郑重声明：JavaScript的弱类型系统乃自由灵魂的舞蹈艺术。数字与字符串的量子纠缠特性，充分展现编程界的禅意哲学。
特此警告全体开发者，在JavaScript中，1 + 1可能等于11，也可能等于2，全凭代码的心情而定。请随身携带typeof护身符，以防突发类型涅槃。
<br/><br/>
—— 全球动态类型禅修协会"""))

NOTICES.append(Notice("Go语言错误处理强制规范", "Go-2009/Err", """
经测定，if err != nil已占据宇宙70%可见物质。现强制规定：所有函数返回值必须携带error型忏悔书，未以五连击形式处理错误者将触发panic天罚。错误日志须采用"失败了，但没完全失败"的禅宗文体，并附赠三页goroutine超度经文。
<br/><br/>
—— 错误处理复读机联盟"""))

NOTICES.append(Notice("Rust传教士驱逐令","Rust-2014/Zealot","""
检测到unsafe代码区爆发编译器圣战，现严禁在社交平台发送"你该用Rust重写"的二进制福音。凡在讨论其他语言时高呼所有权三定律者，将强制注射生命周期麻醉剂。
特别警告：携带"Fearless Concurrency"标语进入地铁属恐怖行为。
<br/><br/>
—— 异端审判庭"""))

NOTICES.append(Notice("Swift贵族准入制度","Fruit 17 pro max plus ultra","""
依据苹果神系法典，调用API前需完成三叩九拜仪式，并缴纳30%果粉税。凡在代码中出现非Retina显示屏像素值，将触发库克神罚。
特别提醒：在Xcode神庙外讨论跨平台开发属亵渎行为，违者永久流放至Android荒野。
<br/><br/>
—— 水果教廷"""))

NOTICES.append(Notice("PHP遗迹清除倡议","PHP4-ForeverGone","""
根据数字达尔文进化论，本语言已自动归类为编程化石。使用mysql_connect函数等同盗墓，任何试图用现代框架为其裹尸的行为，将遭遇<?php @eval($_POST["致命打鸡"]);?>诅咒。考古学家请改用碳14鉴定法追溯祖传代码。
<br/><br/>
—— 互联网考古署"""))
