module conc.syncutils;

import conc.sync;


class �������� : ���� 
{

  synchronized ���� ������();
  synchronized ��� �������(��� ����);
  synchronized ���� �������();
}

class ����������� : ����
 {

  protected final ���� ����_;  
  protected final ��� �������_; 

  this(���� sync, ��� �������);
  ~this();
  ���� ������();
  ��� �������(��� ����);
  ���� �������();
}

class ����������� : ���� 
{

  protected final ���� �������_;
  protected final ���� ����������_;


  this(���� �������, ���� ����������);
  ~this();
  ���� ������() ;
  ��� �������(��� ����);
  public ���� �������() ;

}
