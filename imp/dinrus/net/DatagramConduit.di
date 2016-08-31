module net.DatagramConduit;
public  import  io.device.Conduit;

package import  net.Socket,
                net.SocketConduit;

class ДатаграммПровод : СокетПровод
{

        this ();
        override т_мера читай (проц[] ист);
        т_мера читай (проц[] приёмн, адрес из_);
        override т_мера пиши (проц[] ист);
        т_мера пиши (проц[] ист, адрес в_);
}
