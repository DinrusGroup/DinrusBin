module conc.prioritysemaphore;

import conc.queuedsemaphore;
private import conc.waitnotify;


class ������������������ : ��������������
 {

  this(��� �������������);
  
			  protected class �����ߏ���������������� : �����ߎ������ 
			  {

				protected final �����������.�����ߎ��������Ԏ[] ������_ = 
				  new �����������.�����ߎ��������Ԏ[����.���ѐȎ� -
												 ����.�ȍ�Ȏ� + 1];

				protected ��� ���������_ = -1;

				protected �����ߏ����������������() ;
				protected ���� ������(��������� w) ;
				protected ��������� �������() ;
			  }

}
