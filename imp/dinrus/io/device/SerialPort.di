module io.device.SerialPort;



class СерийныйПорт : Устройство
{
    private ткст              ткт;
    private static ткст[]     _ports;
    
    this (ткст порт);
    override ткст вТкст ();
    СерийныйПорт скорость (бцел скорость);
    static ткст[] порты ();
	
    version(Win32) {
        private проц создай (ткст порт);
    }
    
    version(Posix) {
        private static speed_t[бцел] baudRates;
        
        static this()
        {
            baudRates[50] = B50;
            baudRates[75] = B75;
            baudRates[110] = B110;
            baudRates[134] = B134;
            baudRates[150] = B150;
            baudRates[200] = B200;
            baudRates[300] = B300;
            baudRates[600] = B600;
            baudRates[1200] = B1200;
            baudRates[1800] = B1800;
            baudRates[2400] = B2400;
            baudRates[9600] = B9600;
            baudRates[4800] = B4800;
            baudRates[19200] = B19200;
            baudRates[38400] = B38400;

            version( linux ) 
            { 
                baudRates[57600] = B57600; 
                baudRates[115200] = B115200; 
                baudRates[230400] = B230400; 
                baudRates[460800] = B460800; 
                baudRates[500000] = B500000; 
                baudRates[576000] = B576000; 
                baudRates[921600] = B921600; 
                baudRates[1000000] = B1000000; 
                baudRates[1152000] = B1152000; 
                baudRates[1500000] = B1500000; 
                baudRates[2000000] = B2000000; 
                baudRates[2500000] = B2500000; 
                baudRates[3000000] = B3000000; 
                baudRates[3500000] = B3500000; 
                baudRates[4000000] = B4000000; 
            } 
            else version( freebsd ) 
            { 
                baudRates[7200] = B7200; 
                baudRates[14400] = B14400; 
                baudRates[28800] = B28800; 
                baudRates[57600] = B57600; 
                baudRates[76800] = B76800; 
                baudRates[115200] = B115200; 
                baudRates[230400] = B230400; 
                baudRates[460800] = B460800; 
                baudRates[921600] = B921600; 
            } 
            else version( solaris ) 
            { 
                baudRates[57600] = B57600; 
                baudRates[76800] = B76800; 
                baudRates[115200] = B115200; 
                baudRates[153600] = B153600; 
                baudRates[230400] = B230400; 
                baudRates[307200] = B307200; 
                baudRates[460800] = B460800; 
            }
            else version ( darwin )
            {
                baudRates[7200] = B7200;
                baudRates[14400] = B14400; 
                baudRates[28800] = B28800; 
                baudRates[57600] = B57600; 
                baudRates[76800] = B76800; 
                baudRates[115200] = B115200; 
                baudRates[230400] = B230400; 
            }
        }
        
        private проц создай (ткст файл);        
        private проц makeНеобр (termios *options);
        private static ткст rest (ткст ткт, ткст префикс) ;    
        private static бул isInRange (ткст ткт, сим lower, сим upper) ;
    }    
}

