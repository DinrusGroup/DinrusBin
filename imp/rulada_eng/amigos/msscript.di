module amigos.msscript;

private import os.win32.activex, os.win.tlb.msscriptcontrol; /* for AXO */


class ScriptEngine
{
	private AXO m_axo; 	
	private char[] m_engine = "VBScript";

    this(char[] engine)
    {
		m_engine = engine;
    }

	~this()
	{		
	}
	
	public void start()
	{
		debug writefln("Starting Script Engine...");
		m_axo = new AXO("MSScriptControl.ScriptControl");
		m_axo.set("Language", toVariant(m_engine)); 
	}

	public void run(char[] commandString)
	{		
		debug writefln("run: " ~ commandString);
        m_axo.call("ExecuteStatement", toVariant(commandString)); 
	}
	
	/+
	public  eval(char[] procName,char[] params, OUT VARIANT result)
	{		
		debug writefln("eval: " ~ procName);
        m_axo.call("Eval", toVariant(procName, toVariant(params), result); 
	}
+/
	public void stop()
	{
        m_axo.call("Release"); 
	}

	public void reset()
	{
		m_axo.call("Reset");
	}
	
}

class VBScriptEngine: ScriptEngine
{
	this()
	{
		super("VBScript");
	}		
}	
	
class JScriptEngine: ScriptEngine
{
	this()
	{
		super("JScript");
	}		
}

class ScriptControl
{
    private char[] m_name;
    private char[] m_class_object;
    private bit m_primary = true; /* m_primary is true by default */
	private char[] m_engine = "VBScript";

	private ScriptEngine se; //AXO m_axo; 

    this(char[] n, char[] ClassName)
    {
        this(n, ClassName, m_primary, m_engine);
    }    

    this(char[] n, char[] ClassName, bit primary)
    {
        this(n, ClassName, primary, m_engine);
    }    

    this(char[] n, char[] ClassName, bit primary, char[] engine) /* CreateObject */
    {
        m_name = n;        
        m_class_object = ClassName;
        m_primary = primary;
		m_engine = engine;

        if(m_primary) 
		{
			se = new ScriptEngine(engine);
			se.start();  /* How do I keep this from being called more than once? */
		}
        se.run("Dim " ~ n);
        se.run("Set " ~ n ~ " = CreateObject(\"" ~ ClassName ~ "\")");
    }    

    ~this() 
    {
        if(m_primary) se.stop();  /* _primary is used to keep this from being called more than once */
    }
    
    public void set(char[] prop)
    {
        se.run(m_name ~ "." ~ prop);
    }    

    public void set(char[] prop, char[] val)
    {
        se.run(m_name ~ "." ~ prop ~ " = " ~ val);
    }    	
}



class VBScriptControl: ScriptControl
{

    this(char[] n, char[] ClassName) /* CreateObject */
    {
        super(n, ClassName, true, "VBScript"); /* _primary is true by default */
    }    

    this(char[] n, char[] ClassName, bit primary) /* CreateObject */
    {
		super(n, ClassName, primary, "VBScript"); /* _primary is true by default */
    }    

	~this()
	{
		//~super(); //super.~this();
	}
}



class JScriptControl: ScriptControl
{

    this(char[] n, char[] ClassName) /* CreateObject */
    {
        super(n, ClassName, true, "JScript"); /* _primary is true by default */
    }    

    this(char[] n, char[] ClassName, bit primary) /* CreateObject */
    {
        super(n, ClassName, primary, "JScript"); /* _primary is true by default */
    }    

	~this()
	{
		//super.~this();
	}
}

private VBScriptEngine eng;
bool engStarted = false;

void vbs(string stat)
	{
	if(!engStarted)
	{
	eng = new VBScriptEngine();
	eng.start();
	engStarted = true;
	}	
	eng.run(stat);	
	}
	
void endvbs()
	{
	if(engStarted)
	eng.stop();
	}
	
void vbso(char[] name, char[] obj)
	{
	string a = ("Dim "~name~": Set "~name~" = CreateObject(\""~obj~"\")");
	vbs(a);	
	}
void vbset(char[] name, char[] obj)
	{
	string a = ("Set "~name~" = "~obj);
	vbs(a);	
	}
	
private JScriptEngine jeng;
bool jsengStarted = false;

void js(string stat)
	{
	if(!jsengStarted)
	{
	jeng = new JScriptEngine();
	jeng.start();
	jsengStarted = true;
	}	
	jeng.run(stat);	
	}
	
void endjs()
	{
	if(jsengStarted)
	jeng.stop();
	}
/*	
void vbso(char[] name, char[] obj)
	{
	string a = ("Dim "~name~": Set "~name~" = CreateObject(\""~obj~"\")");
	js(a);	
	}
void vbset(char[] name, char[] obj)
	{
	string a = ("Set "~name~" = "~obj);
	vbs(a);	
	}
*/

version (build) {
    debug {
        pragma(link, "amigos");
    } else {
        pragma(link, "amigos");
    }
}
