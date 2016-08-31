module mango.containers.ListMutators;

import mango.containers.List;

template Reverse(V) {
  void go(MutableList!(V) list, void* _argptr, TypeInfo[] _arguments) {
    int len = list.length();
    for(int i=0; i<len/2; i++) {
      list.swap(i,len-1-i);
    }
  }
}

template MergeSort(V) {
  void go(MutableList!(V) list, void* _argptr, TypeInfo[] _arguments) {
    mergeSort(list, 0, list.size()-1);
  }

  void mergeSort(MutableList!(V) list, uint left, uint right) {
    if (left < right) {
      uint middle = cast(uint)((left+right)/2);
      mergeSort(list, left, middle);
      mergeSort(list, middle+1, right);
      merge(list, left, middle, right);
    }
  }

  void merge(MutableList!(V) list, uint left, uint middle, uint right) {
    auto V[] ret = new V[right-left+1];
    uint pos = 0;
    uint leftp = left;
    uint rightp = middle+1;
    while (leftp <= middle && rightp <= right) {
      if (list[leftp] < list[rightp]) {
	ret[pos++] = list[leftp++];
      } else {
	ret[pos++] = list[rightp++];
      }
    }

    while (leftp <= middle) {
      ret[pos++] = list[leftp++];
    }
    
    while (rightp <= right) {
      ret[pos++] = list[rightp++];
    }

    for(pos=0; pos<ret.length; pos++) {
      list[pos+left] = ret[pos];
    }

    delete ret;
  }
}

version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
