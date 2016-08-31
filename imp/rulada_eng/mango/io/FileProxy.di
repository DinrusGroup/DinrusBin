/*******************************************************************************

        @file FileProxy.d
        
        Copyright (c) 2004 Kris Bell
        
        This software is provided 'as-is', without any express or implied
        warranty. In no event will the authors be held liable for damages
        of any kind arising from the use of this software.
        
        Permission is hereby granted to anyone to use this software for any 
        purpose, including commercial applications, and to alter it and/or 
        redistribute it freely, subject to the following restrictions:
        
        1. The origin of this software must not be misrepresented; you must 
           not claim that you wrote the original software. If you use this 
           software in a product, an acknowledgment within documentation of 
           said product would be appreciated but is not required.

        2. Altered source versions must be plainly marked as such, and must 
           not be misrepresented as being the original software.

        3. This notice may not be removed or altered from any distribution
           of the source.

        4. Derivative works are permitted, but they must carry this notice
           in full and credit the original source.


                        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                        

        @version        Initial version, March 2004      

        @author         Kris
                        Brad Anderson
                        teqdruid
                        Anders (Darwin support)
                        Chris Sauls (Win95 file support)

*******************************************************************************/

module mango.io.FileProxy;

private import  mango.sys.OS;

private import  mango.io.FilePath,
                mango.io.Exception;

private import  mango.convert.Unicode;

private import  mango.io.model.IWriter;
 
version (Win32)
        {
        version (Win32SansUnicode)
                {
                private extern (C) int strlen (char *s);
                private alias WIN32_FIND_DATA FIND_DATA;
                }
             else
                {
                private extern (C) int wcslen (wchar *s);
                private alias WIN32_FIND_DATAW FIND_DATA;
                }
        }


version (Posix)
        {
        private extern (C) int strlen (char *s);

        private import std.c.stdio;

        version (darwin)
                {
                // missing from std.c.darwin.darwin in GDC 0.9 :

                alias long off_t;

                extern (C)
                       {
                       struct  dirent
                               {
                               int      d_ino;
                               off_t    d_off;
                               ushort   d_reclen;
                               ubyte    d_type;
                               char[256] d_name;
                               }

                       struct DIR
                             {
                             // Managed by OS.
                             }

                       DIR* opendir(char* name);
                       int closedir(DIR* dir);
                       dirent* readdir(DIR* dir);
                       void rewinddir(DIR* dir);
                       off_t telldir(DIR* dir);
                       void seekdir(DIR* dir, off_t offset);
                       }
                }
        }


/*******************************************************************************

        Models a generic file. Use this to manipulate files and directories
        in conjunction with FilePath, FileSystem and FileConduit. Doxygen
        has a hard time with D version() statements, so part of this class
        is documented in FileProxy::VersionWin32 instead.

        Compile with -version=Win32SansUnicode to enable Win95 & Win32s file
        support.
        
*******************************************************************************/

class FileProxy : IWritable
{
        private FilePath path;

        /***********************************************************************
        
                Construct a FileProxy from the provided FilePath

        ***********************************************************************/
                                  
        this (FilePath path)
        {
                this.path = path;
        }

        /***********************************************************************
        
                Construct a FileProxy from a text string

        ***********************************************************************/

        this (char[] path)
        {
                this (new FilePath (path));
        }

        /***********************************************************************
        
                Return the FilePath associated with this FileProxy

        ***********************************************************************/

        FilePath getPath ()
        {
                return path;
        }               

        /***********************************************************************
        
                Return the name of the associated path

        ***********************************************************************/

        char[] toString ()
        {
                return path.toString();
        }               

        /***********************************************************************
        
                Does this path currently exist?

        ***********************************************************************/

        bool isExisting ()               
        {
                try {
                    getSize();
                    return true;
                    } catch (IOException){}
                return false;
        }            

        /***********************************************************************
        
                List the files contained within the associated path:

                @code
                FileProxy proxy = new FileProxy (".");

                foreach (FilePath path; proxy.toList())
                         Stdout.put(path).cr();
                @endcode

        ***********************************************************************/

        FilePath[] toList ()
        {

                return toList (delegate bool(FilePath fp) {return true;});
        }              

        /***********************************************************************
        
                Write this FileProxy to the given IWriter. We just emit 
                the filepath, since that's what we represent.

        ***********************************************************************/

        void write (IWriter emit)
        {
                emit (path);
        }

        /***********************************************************************

        ***********************************************************************/

        version (Win32)
        {
                /***************************************************************

                        Throw an exception using the last known error

                ***************************************************************/

                private void exception ()
                {
                        throw new IOException (path.toString ~ ": " ~ OS.error);
                }

                /***************************************************************

                        Get info about this path

                ***************************************************************/

                private uint getInfo (void delegate (inout FIND_DATA info) dg)
                {
                        FIND_DATA info;

                        version (Win32SansUnicode)
                                 HANDLE h = FindFirstFileA (path.toUtf8, &info);
                             else
                                HANDLE h = FindFirstFileW (cast(wchar*)(path.toUtf16), &info);

                        if (h == INVALID_HANDLE_VALUE)
                            exception ();

                        if (dg)
                            dg (info);
                        FindClose (h);

                        return info.dwFileAttributes;
                }

                /***************************************************************
                        
                        Return the file length (in bytes)

                ***************************************************************/

                ulong getSize ()
                {
                        ulong _size;

                        void size (inout FIND_DATA info)
                        {
                                _size = (cast(ulong) info.nFileSizeHigh << 32) + 
                                                     info.nFileSizeLow;
                        }

                        getInfo (&size);
                        return _size;
                }

                /***************************************************************

                        Is this file writable?

                ***************************************************************/

                bool isWritable ()               
                {
                        return cast (bool) ((getInfo(null) & FILE_ATTRIBUTE_READONLY) == 0);
                }            

                /***************************************************************

                        Is this file really a directory?

                ***************************************************************/

                bool isDirectory ()               
                {
                        return cast(bool) ((getInfo(null) & FILE_ATTRIBUTE_DIRECTORY) != 0);
                }            

                /***************************************************************

                        Return the time when the file was last modified

                ***************************************************************/

                ulong getModifiedTime ()
                {
                        ulong _time;

                        void time (inout FIND_DATA info)
                        {
                                _time = (cast(ulong) info.ftLastWriteTime.dwHighDateTime << 32) + 
                                                     info.ftLastWriteTime.dwLowDateTime;
                        }

                        getInfo (&time);
                        return _time;
                }               

                /***************************************************************

                        Return the time when the file was last accessed

                ***************************************************************/

                ulong getAccessedTime ()
                {
                        ulong _time;

                        void time (inout FIND_DATA info)
                        {
                                _time = (cast(ulong) info.ftLastAccessTime.dwHighDateTime << 32) + 
                                                     info.ftLastAccessTime.dwLowDateTime;
                        }

                        getInfo (&time);
                        return _time;
                }               

                /***************************************************************

                        Return the time when the file was created

                ***************************************************************/

                ulong getCreatedTime ()
                {
                        ulong _time;

                        void time (inout FIND_DATA info)
                        {
                                _time = (cast(ulong) info.ftCreationTime.dwHighDateTime << 32) + 
                                                     info.ftCreationTime.dwLowDateTime;
                        }

                        getInfo (&time);
                        return _time;
                }               

                /***************************************************************

                        Remove the file/directory from the file-system

                ***************************************************************/

                void remove ()
                {
                        if (isDirectory ())
                           {
                           version (Win32SansUnicode)
                                   {
                                   if (! RemoveDirectoryA (path.toUtf8))
                                         exception();
                                   }
                                else
                                   {
                                   if (! RemoveDirectoryW (cast(wchar*) path.toUtf16))
                                         exception();
                                   }
                           }
                        else
                           version (Win32SansUnicode)
                                   {
                                   if (! DeleteFileA (path.toUtf8))
                                         exception();
                                   }
                                else
                                   {
                                   if (! DeleteFileW (cast(wchar*)(path.toUtf16)))
                                         exception();
                                   }
                }           

                /***************************************************************

                        Create a new file 

                ***************************************************************/

                FileProxy createFile ()
                {
                        HANDLE h;

                        version (Win32SansUnicode)
                                 h = CreateFileA (path.toUtf8, GENERIC_WRITE, 
                                                  0, null, CREATE_ALWAYS, 
                                                  FILE_ATTRIBUTE_NORMAL, null);
                             else
                                h = CreateFileW (cast(wchar*) path.toUtf16, GENERIC_WRITE, 
                                                 0, null, CREATE_ALWAYS, 
                                                 FILE_ATTRIBUTE_NORMAL, null);

                        if (h == INVALID_HANDLE_VALUE)
                            exception ();

                        if (! CloseHandle (h))
                              exception ();

                        return this;
                }

                /***************************************************************

                        Create a new directory

                ***************************************************************/

                FileProxy createDirectory ()
                {
                        version (Win32SansUnicode)
                                {
                                if (! CreateDirectoryA (path.toUtf8, null))
                                      exception();
                                }
                             else
                                {
                                if (! CreateDirectoryW (cast(wchar*) path.toUtf16, null))
                                      exception();
                                }
                        return this;
                }

                /***************************************************************
                        
                        List the set of children within this directory. See
                        toList() above.

                ***************************************************************/

                FilePath[] toList (bool delegate(FilePath fp) filter)
                {
                        int                     i;
                        wchar[]                 c;
                        HANDLE                  h;
                        FilePath                fp;
                        FilePath[]              list;
                        FIND_DATA               fileinfo;

                        int next()
                        {
                                version (Win32SansUnicode)
                                         return FindNextFileA (h, &fileinfo);
                                     else
                                         return FindNextFileW (h, &fileinfo);
                        }
                        
                        list = new FilePath[50];

                        version (Win32SansUnicode)
                                h = FindFirstFileA (path.toUtf8 ~ "\\*\0", &fileinfo);
                             else
                                h = FindFirstFileW (cast(wchar*)(path.toUtf16 ~ cast(wchar[]) "\\*\0"), &fileinfo);

                        if (h != INVALID_HANDLE_VALUE)
                            try {
                                do {
                                   // make a copy of the file name for listing
                                   version (Win32SansUnicode)
                                           {
                                           int len = strlen (fileinfo.cFileName);
                                           fp = new FilePath (fileinfo.cFileName [0 .. len]);
                                           }
                                        else
                                           {
                                           int len = wcslen (cast(wchar*)fileinfo.cFileName);
                                           fp = new FilePath (Unicode.toUtf8(fileinfo.cFileName [0 .. len]));                                           
                                           }

                                   if (i >= list.length)
                                      list.length = list.length * 2;

                                   if (filter (fp))
                                      {
                                      list[i] = fp;
                                      ++i;
                                      }
                                   } while (next);
                                } finally {
                                          FindClose (h);
                                          }
                        list.length = i;
                        return list;
                }
        }

        /***********************************************************************

        ***********************************************************************/

        version (Posix)
        {
                /***************************************************************

                        Throw an exception using the last known error

                ***************************************************************/

                private void exception ()
                {
                        throw new IOException (path.toString ~ ": " ~ OS.error);
                }

                /***************************************************************

                        Get info about this path

                ***************************************************************/

                private uint getInfo (void delegate (inout struct_stat info) dg)
                {
                        struct_stat stats;

                        if (posix.stat (path.toUtf8, &stats))
                            exception();

                        if (dg)
                            dg (stats);

                        return stats.st_mode;
                }               

                /***************************************************************

                        Return the file length (in bytes)

                ***************************************************************/

                ulong getSize ()
                {
                        ulong _size;

                        void size (inout struct_stat info)
                        {
                                _size = cast(ulong) info.st_size;    // 32 bits only
                        }

                        getInfo (&size);
                        return _size;
                }

                /***************************************************************

                        Is this file writable?

                ***************************************************************/

                bool isWritable ()               
                {
                        return (getInfo(null) & O_RDONLY) == 0;
                }            

                /***************************************************************

                        Is this file really a directory?

                ***************************************************************/

                bool isDirectory ()               
                {
                        return (getInfo(null) & S_IFDIR) != 0;
                }            

                /***************************************************************

                        Return the time when the file was last modified

                ***************************************************************/

                ulong getModifiedTime ()
                {
                        ulong _time;

                        void time (inout struct_stat info)
                        {
                               _time = cast(ulong) info.st_mtime;
                        }

                        getInfo (&time);
                        return _time;
                }               

                /***************************************************************

                        Return the time when the file was last accessed

                ***************************************************************/

                ulong getAccessedTime ()
                {
                        ulong _time;

                        void time (inout struct_stat info)
                        {
                               _time = cast(ulong) info.st_atime;
                        }

                        getInfo (&time);
                        return _time;
                }               

                /***************************************************************

                        Return the time when the file was created

                ***************************************************************/

                ulong getCreatedTime ()
                {
                        ulong _time;

                        void time (inout struct_stat info)
                        {
                               _time = cast(ulong) info.st_ctime;
                        }

                        getInfo (&time);
                        return _time;
                }               

                /***************************************************************

                        Remove the file/directory from the file-system

                ***************************************************************/

                void remove ()
                {
                        if (isDirectory())
                           {
                           if (posix.rmdir (path.toUtf8))
                               exception ();
                           }
                        else           
                           if (std.c.stdio.remove (path.toUtf8) == -1)
                               exception ();
                }              

                /***************************************************************

                        Create a new file 

                ***************************************************************/

                FileProxy createFile ()
                {
                        int fd;

                        fd = posix.open (path.toUtf8, O_CREAT | O_WRONLY | O_TRUNC, 0660);
                        if (fd == -1)
                            exception();

                        if (posix.close(fd) == -1)
                            exception();

                        return this;
                }              

                /***************************************************************

                        Create a new directory

                ***************************************************************/

                FileProxy createDirectory ()
                {
                        if (posix.mkdir (path.toUtf8, 0777))
                            exception();

                        return this;
                }

                /***************************************************************
                
                        List the set of children within this directory. See
                        toList() above.

                ***************************************************************/

                FilePath[] toList (bool delegate(FilePath fp) filter)
                {
                        int             i;
                        DIR*            dir;
                        dirent*         entry;
                        FilePath[]      list;

                        dir = opendir (path.toUtf8);
                        if (! dir) 
                              exception();

                        list = new FilePath [50];
                        while ((entry = readdir(dir)) != null)
                              {
                              int len = strlen (entry.d_name);

                              // make a copy of the file name for listing
                              FilePath fp = new FilePath (entry.d_name[0 ..len].dup);

                              if (i >= list.length)
                                  list.length = list.length * 2;

                              if (filter (fp))
                                 {
                                 list[i] = fp;
                                 ++i;
                                 }
                              }  

                        list.length = i;
                        closedir (dir);
                        return list;
                }

        }
}


version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
