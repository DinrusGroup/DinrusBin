/*******************************************************************************

        @file PickleRegistry.d
        
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


        @version        Initial version, April 2004      
        @author         Kris


*******************************************************************************/

module mango.io.PickleRegistry;

private import  mango.io.Exception;
        
public  import  mango.io.model.IReader,
                mango.io.model.IPickle;

/*******************************************************************************

        Bare framework for registering and creating serializable objects.
        Such objects are intended to be transported across a local network
        and re-instantiated at some destination node. 

        Each IPickle exposes the means to write, or freeze, its content. An
        IPickleFactory provides the means to create a new instance of itself
        populated with thawed data. Frozen objects are uniquely identified 
        by a guid exposed via the interface. Responsibility of maintaining
        uniqueness across said identifiers lies in the hands of the developer.

        See PickleReader for an example of how this is expected to operate.

*******************************************************************************/

class PickleRegistry
{
        private static Proxy[char[]] registry;

        /***********************************************************************
        
        ***********************************************************************/

        alias Object function (IReader reader) SimpleProxyFnc;
        alias Object function (IReader reader, char[] guid) GuidProxyFnc;

        /***********************************************************************
        
                This is a singleton: the constructor should not be exposed

        ***********************************************************************/

        private this ()
        {
        }

        /***********************************************************************
        
                Base registrar entry

        ***********************************************************************/

        private static class Proxy
        {
                abstract Object create (IReader reader);
        }

        /***********************************************************************
        
                Simple registrar entry

        ***********************************************************************/

        private static class SimpleProxy : Proxy
        {
                SimpleProxyFnc  fnc;

                /***************************************************************
        
                ***************************************************************/
              
                this (SimpleProxyFnc fnc)
                {
                        this.fnc = fnc;
                }

                /***************************************************************
        
                ***************************************************************/
              
                Object create (IReader reader)
                {       
                        return fnc (reader);
                }
        }

        /***********************************************************************
        
                Guid registrar entry

        ***********************************************************************/

        private static class GuidProxy : Proxy
        {
                GuidProxyFnc    fnc;
                char[]          guid;

                /***************************************************************
        
                ***************************************************************/
              
                this (GuidProxyFnc fnc, char[] guid)
                {
                        this.fnc = fnc;
                        this.guid = guid;
                }

                /***************************************************************
        
                ***************************************************************/
              
                Object create (IReader reader)
                {       
                        return fnc (reader, guid);
                }
        }

        /***********************************************************************
        
                IPickleFactory registrar entry

        ***********************************************************************/

        private static class PickleProxy : Proxy
        {
                IPickleFactory  factory;

                /***************************************************************
        
                ***************************************************************/
              
                this (IPickleFactory factory)
                {
                        this.factory = factory;
                }

                /***************************************************************
        
                ***************************************************************/
              
                Object create (IReader reader)
                {       
                        return factory.create (reader);
                }
        }

        /***********************************************************************
        
                Add the provided class to the registry. Note that one
                cannot change a registration once it is placed. Neither
                can one remove registered item. This is done to avoid 
                major issues when trying to synchronize servers across
                a farm, which may still have live instances of "old"
                objects waiting to be passed around the cluster. New
                versions of an object should be given a distinct guid
                from the prior version; appending an incremental number 
                may well be sufficient for your needs.

        ***********************************************************************/

        private static synchronized void enroll (Proxy proxy, char[] guid)
        {
                if (guid in registry)
                    throw new PickleException ("Invalid attempt to re-register a guid");
        
                registry[guid] = proxy;
        }

        /***********************************************************************
        
                do a synchronized Proxy lookup of the guid

        ***********************************************************************/

        private final static synchronized Proxy lookup (char[] guid)
        {
                Proxy* p = guid in registry;
                if (p)
                    return *p;
                return null;
        }

        /***********************************************************************
        
                Add the provided object to the registry. Note that one
                cannot change a registration once it is placed. Neither
                can one remove registered item. This is done to avoid 
                major issues when trying to synchronize servers across
                a farm, which may still have live instances of "old"
                objects waiting to be passed around the cluster. New
                versions of an object should be given a distinct guid
                from the prior version; appending an incremental number 
                may well be sufficient for your needs.

        ***********************************************************************/

        static void enroll (IPickleFactory object)
        {
                enroll (new PickleProxy(object), object.getGuid);
        }

        /***********************************************************************
        
                Add the provided function to the registry. Note that one
                cannot change a registration once it is placed. Neither
                can one remove registered item. This is done to avoid 
                major issues when trying to synchronize servers across
                a farm, which may still have live instances of "old"
                objects waiting to be passed around the cluster. New
                versions of an object should be given a distinct guid
                from the prior version; appending an incremental number 
                may well be sufficient for your needs.

        ***********************************************************************/

        static void enroll (SimpleProxyFnc sp, char[] guid)
        {
                enroll (new SimpleProxy(sp), guid);
        }

        /***********************************************************************
        
                Add the provided function to the registry. Note that one
                cannot change a registration once it is placed. Neither
                can one remove registered item. This is done to avoid 
                major issues when trying to synchronize servers across
                a farm, which may still have live instances of "old"
                objects waiting to be passed around the cluster. New
                versions of an object should be given a distinct guid
                from the prior version; appending an incremental number 
                may well be sufficient for your needs.

        ***********************************************************************/

        static void enroll (GuidProxyFnc gp, char[] guid)
        {
                enroll (new GuidProxy(gp, guid), guid);
        }

        /***********************************************************************
        
                Create a new instance of a registered class from the content
                made available via the given reader. The factory is located
                using the provided guid, which must match an enrolled class.

                Note that only the factory lookup is synchronized, and not 
                the instance construction itself.

        ***********************************************************************/

        static Object create (IReader reader, char[] guid)
        {
                // locate the appropriate Proxy. 
                Proxy p = lookup (guid);
                if (p)
                    return p.create (reader);

                throw new PickleException ("Attempt to unpickle via unregistered guid '"~guid~"'");
        }
}


version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
