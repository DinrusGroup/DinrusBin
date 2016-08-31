
module io.protocol.PickleProtocol;

version (БигЭндиан)
        {
        private import io.protocol.NativeProtocol;
        public alias ПротоколНатив ПротоколПикл;
        }
     else
        {
        private import io.protocol.EndianProtocol;
        public alias ПротоколЭндиан ПротоколПикл;
        }
