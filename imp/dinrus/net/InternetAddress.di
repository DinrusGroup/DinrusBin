module net.InternetAddress;

private import net.device.Berkeley;

class АдресИнтернета : АдресИПв4
{

        this();
        this (ткст адр, цел порт = ПОРТ_ЛЮБОЙ);
        this (бцел адр, бкрат порт);
        this (бкрат порт);
        private static цел разбор (ткст s);
}
