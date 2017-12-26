module dwt.internal.mozilla.nsISerializable;

import dwt.internal.mozilla.Common;
import dwt.internal.mozilla.nsID;
import dwt.internal.mozilla.nsISupports;

import dwt.internal.mozilla.nsIObjectInputStream; 
import dwt.internal.mozilla.nsIObjectOutputStream;

const char[] NS_ISERIALIZABLE_IID_STR = "91cca981-c26d-44a8-bebe-d9ed4891503a";

const nsIID NS_ISERIALIZABLE_IID= 
  {0x91cca981, 0xc26d, 0x44a8, 
    [ 0xbe, 0xbe, 0xd9, 0xed, 0x48, 0x91, 0x50, 0x3a ]};

interface nsISerializable : nsISupports {

  static const char[] IID_STR = NS_ISERIALIZABLE_IID_STR;
  static const nsIID IID = NS_ISERIALIZABLE_IID;

extern(System):
  nsresult Read(nsIObjectInputStream aInputStream);
  nsresult Write(nsIObjectOutputStream aOutputStream);

}

