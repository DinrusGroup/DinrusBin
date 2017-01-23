/*******************************************************************************

        Copyright: Copyright (C) 2007-2008 Scott Sanders, Kris Bell.  
                   все rights reserved.

        License:   BSD стиль: $(LICENSE)

        version:   Initial release: February 2008      

        Authors:   stonecobra, Kris

        Acknowledgements: 
                   Many thanks в_ the entire группа that came up with
                   SAX as an API, и then had the foresight в_ place
                   it преобр_в the public домен so that it can become a
                   de-facto стандарт.  It may not be the best XML API, 
                   but it sure is handy. For ещё information, see 
                   <a href='http://www.saxproject.org'>http://www.saxproject.org</a>.

*******************************************************************************/

module text.xml.SaxParser;

private import io.model;
private import text.xml.PullParser;

/*******************************************************************************

        Single атрибуты are represented by this struct.

 *******************************************************************************/
struct Атрибут(Ch = сим) {

        Ch[] localName;
        Ch[] значение;

}

/*******************************************************************************
 * принять notification of the logical контент of a document.
 *
 * <p>This is the main interface that most SAX applications
 * implement: if the application needs в_ be informed of basic parsing 
 * события, it реализует this interface и registers an экземпляр with 
 * the SAX парсер using the {@link org.xml.sax.XMLЧитатель#setContentHandler 
 * setContentHandler} метод.  The парсер uses the экземпляр в_ report 
 * basic document-related события like the старт и конец of элементы 
 * и character данные.</p>
 *
 * <p>The order of события in this interface is very important, и
 * mirrors the order of information in the document itself.  For
 * example, все of an элемент's контент (character данные, processing
 * instructions, и/or subelements) will appear, in order, between
 * the startElement событие и the corresponding endElement событие.</p>
 *
 * <p>This interface is similar в_ the сейчас-deprecated SAX 1.0
 * DocumentHandler interface, but it добавьs support for Namespaces
 * и for reporting skИПped entities (in non-validating XML
 * processors).</p>
 *
 * <p>Implementors should note that there is also a 
 * <код>ContentHandler</код> class in the <код>java.net</код>
 * package; that means that it's probably a bad опрea в_ do</p>
 *
 * <pre>import java.net.*;
 * import org.xml.sax.*;
 * </pre>
 *
 * <p>In fact, "import ...*" is usually a знак of sloppy programming
 * anyway, so the пользователь should consопрer this a feature rather than a
 * bug.</p>
 *
 * @since SAX 2.0
 * @author David Megginson
 * @version 2.0.1+ (sax2r3pre1)
 * @see org.xml.sax.XMLЧитатель
 * @see org.xml.sax.ErrorHandler
 *******************************************************************************/
public class SaxHandler(Ch = сим) {
        
        Locator!(Ch) locator;

        /*******************************************************************************
         * принять an объект for locating the origin of SAX document события.
         *
         * <p>SAX parsers are strongly encouraged (though not absolutely
         * требуется) в_ supply a locator: if it does so, it must supply
         * the locator в_ the application by invoking this метод before
         * invoking any of the другой methods in the ContentHandler
         * interface.</p>
         *
         * <p>The locator allows the application в_ determine the конец
         * позиция of any document-related событие, even if the парсер is
         * not reporting an ошибка.  Typically, the application will
         * use this information for reporting its own ошибки (such as
         * character контент that does not сверь an application's
         * business rules).  The information returned by the locator
         * is probably not sufficient for use with a ищи движок.</p>
         *
         * <p>Note that the locator will return correct information only
         * during the invocation SAX событие обрвызовы after
         * {@link #startDocument startDocument} returns и before
         * {@link #endDocument endDocument} is called.  The
         * application should not attempt в_ use it at any другой время.</p>
         *
         * @param locator an объект that can return the location of
         *                any SAX document событие
         * @see org.xml.sax.Locator
         *******************************************************************************/
        public проц setDocumentLocator(Locator!(Ch) locator)
        {
                this.locator = locator;
        }

        /*******************************************************************************
         * принять notification of the beginning of a document.
         *
         * <p>The SAX парсер will invoke this метод only once, before any
         * другой событие обрвызовы (except for {@link #setDocumentLocator 
         * setDocumentLocator}).</p>
         *
         * @throws org.xml.sax.SAXException any SAX исключение, possibly
         *            wrapping другой исключение
         * @see #endDocument
         *******************************************************************************/
        public проц startDocument()
        {
                
        }

        /*******************************************************************************
         * принять notification of the конец of a document.
         *
         * <p><strong>There is an apparent contradiction between the
         * documentation for this метод и the documentation for {@link
         * org.xml.sax.ErrorHandler#fatalError}.  Until this ambiguity is
         * resolved in a future major release, clients should сделай no
         * assumptions about whether endDocument() will or will not be
         * invoked when the парсер имеется reported a fatalError() or thrown
         * an исключение.</strong></p>
         *
         * <p>The SAX парсер will invoke this метод only once, и it will
         * be the последний метод invoked during the разбор.  The парсер shall
         * not invoke this метод until it имеется either abandoned parsing
         * (because of an unrecoverable ошибка) or reached the конец of
         * ввод.</p>
         *
         * @throws org.xml.sax.SAXException any SAX исключение, possibly
         *            wrapping другой исключение
         * @see #startDocument
         *******************************************************************************/
        public проц endDocument()
        {
                
        }

        /*******************************************************************************
         * Начало the scope of a префикс-URI Namespace маппинг.
         *
         * <p>The information из_ this событие is not necessary for
         * нормаль Namespace processing: the SAX XML читатель will 
         * automatically замени prefixes for элемент и attribute
         * names when the <код>http://xml.org/sax/features/namespaces</код>
         * feature is <var>да</var> (the default).</p>
         *
         * <p>There are cases, however, when applications need в_
         * use prefixes in character данные or in attribute значения,
         * where they cannot safely be expanded automatically; the
         * старт/endPrefixMapping событие supplies the information
         * в_ the application в_ расширь prefixes in those contexts
         * itself, if necessary.</p>
         *
         * <p>Note that старт/endPrefixMapping события are not
         * guaranteed в_ be properly nested relative в_ each другой:
         * все startPrefixMapping события will occur immediately before the
         * corresponding {@link #startElement startElement} событие, 
         * и все {@link #endPrefixMapping endPrefixMapping}
         * события will occur immediately after the corresponding
         * {@link #endElement endElement} событие,
         * but their order is not otherwise 
         * guaranteed.</p>
         *
         * <p>There should never be старт/endPrefixMapping события for the
         * "xml" префикс, since it is predeclared и immutable.</p>
         *
         * @param префикс the Namespace префикс being declared.
         * An пустой ткст is использован for the default элемент namespace,
         * which имеется no префикс.
         * @param уир the Namespace URI the префикс is mapped в_
         * @throws org.xml.sax.SAXException the клиент may throw
         *            an исключение during processing
         * @see #endPrefixMapping
         * @see #startElement
         *******************************************************************************/
        public проц startPrefixMapping(Ch[] префикс, Ch[] уир)
        {
                
        }

        /*******************************************************************************
         * End the scope of a префикс-URI маппинг.
         *
         * <p>See {@link #startPrefixMapping startPrefixMapping} for 
         * details.  These события will always occur immediately after the
         * corresponding {@link #endElement endElement} событие, but the order of 
         * {@link #endPrefixMapping endPrefixMapping} события is not otherwise
         * guaranteed.</p>
         *
         * @param префикс the префикс that was being mapped.
         * This is the пустой ткст when a default маппинг scope заканчивается.
         * @throws org.xml.sax.SAXException the клиент may throw
         *            an исключение during processing
         * @see #startPrefixMapping
         * @see #endElement
         *******************************************************************************/
        public проц endPrefixMapping(Ch[] префикс)
        {
                
        }

        /*******************************************************************************
         * принять notification of the beginning of an элемент.
         *
         * <p>The Parser will invoke this метод at the beginning of every
         * элемент in the XML document; there will be a corresponding
         * {@link #endElement endElement} событие for every startElement событие
         * (even when the элемент is пустой). все of the элемент's контент will be
         * reported, in order, before the corresponding endElement
         * событие.</p>
         *
         * <p>This событие allows up в_ three имя components for each
         * элемент:</p>
         *
         * <ol>
         * <li>the Namespace URI;</li>
         * <li>the local имя; и</li>
         * <li>the qualified (псеп_в_начале) имя.</li>
         * </ol>
         *
         * <p>Any or все of these may be provопрed, depending on the
         * значения of the <var>http://xml.org/sax/features/namespaces</var>
         * и the <var>http://xml.org/sax/features/namespace-prefixes</var>
         * свойства:</p>
         *
         * <ul>
         * <li>the Namespace URI и local имя are требуется when 
         * the namespaces property is <var>да</var> (the default), и are
         * optional when the namespaces property is <var>нет</var> (if one is
         * specified, Всё must be);</li>
         * <li>the qualified имя is требуется when the namespace-prefixes property
         * is <var>да</var>, и is optional when the namespace-prefixes property
         * is <var>нет</var> (the default).</li>
         * </ul>
         *
         * <p>Note that the attribute список provопрed will contain only
         * атрибуты with явный значения (specified or defaulted):
         * #IMPLIED атрибуты will be omitted.  The attribute список
         * will contain атрибуты использован for Namespace declarations
         * (xmlns* атрибуты) only if the
         * <код>http://xml.org/sax/features/namespace-prefixes</код>
         * property is да (it is нет by default, и support for a 
         * да значение is optional).</p>
         *
         * <p>Like {@link #characters characters()}, attribute значения may have
         * characters that need ещё than one <код>сим</код> значение.  </p>
         *
         * @param уир the Namespace URI, or the пустой ткст if the
         *        элемент имеется no Namespace URI or if Namespace
         *        processing is not being performed
         * @param localName the local имя (without префикс), or the
         *        пустой ткст if Namespace processing is not being
         *        performed
         * @param qName the qualified имя (with префикс), or the
         *        пустой ткст if qualified names are not available
         * @param atts the атрибуты attached в_ the элемент.  If
         *        there are no атрибуты, it shall be an пустой
         *        Attributes объект.  The значение of this объект after
         *        startElement returns is undefined
         * @throws org.xml.sax.SAXException any SAX исключение, possibly
         *            wrapping другой исключение
         * @see #endElement
         * @see org.xml.sax.Attributes
         * @see org.xml.sax.helpers.AttributesImpl
         *******************************************************************************/
        public проц startElement(Ch[] уир, Ch[] localName, Ch[] qName, Атрибут!(Ch)[] atts)
        {
                
        }

        /*******************************************************************************
         * принять notification of the конец of an элемент.
         *
         * <p>The SAX парсер will invoke this метод at the конец of every
         * элемент in the XML document; there will be a corresponding
         * {@link #startElement startElement} событие for every endElement 
         * событие (even when the элемент is пустой).</p>
         *
         * <p>For information on the names, see startElement.</p>
         *
         * @param уир the Namespace URI, or the пустой ткст if the
         *        элемент имеется no Namespace URI or if Namespace
         *        processing is not being performed
         * @param localName the local имя (without префикс), or the
         *        пустой ткст if Namespace processing is not being
         *        performed
         * @param qName the qualified XML имя (with префикс), or the
         *        пустой ткст if qualified names are not available
         * @throws org.xml.sax.SAXException any SAX исключение, possibly
         *            wrapping другой исключение
         *******************************************************************************/
        public проц endElement(Ch[] уир, Ch[] localName, Ch[] qName)
        {
                
        }

        /*******************************************************************************
         * принять notification of character данные.
         *
         * <p>The Parser will вызов this метод в_ report each чанк of
         * character данные.  SAX parsers may return все contiguous character
         * данные in a single чанк, or they may разбей it преобр_в several
         * чанки; however, все of the characters in any single событие
         * must come из_ the same external сущность so that the Locator
         * provопрes useful information.</p>
         *
         * <p>The application must not attempt в_ читай из_ the Массив
         * outsопрe of the specified range.</p>
         *
         * <p>Indivопрual characters may consist of ещё than one Java
         * <код>сим</код> значение.  There are two important cases where this
         * happens, because characters can't be represented in just sixteen биты.
         * In one case, characters are represented in a <em>Surrogate Пара</em>,
         * using two special Unicode значения. Such characters are in the so-called
         * "Astral Planes", with a код точка above U+FFFF.  A секунда case involves
         * composite characters, such as a основа character combining with one or
         * ещё accent characters. </p>
         *
         * <p> Your код should not assume that algorithms using
         * <код>сим</код>-at-a-время опрioms will be working in character
         * units; in some cases they will разбей characters.  This is relevant
         * wherever XML permits arbitrary characters, such as attribute значения,
         * processing instruction данные, и comments as well as in данные reported
         * из_ this метод.  It's also generally relevant whenever Java код
         * manИПulates internationalized текст; the issue isn't unique в_ XML.</p>
         *
         * <p>Note that some parsers will report пробел in элемент
         * контент using the {@link #ignorableWhitespace ignorableWhitespace}
         * метод rather than this one (validating parsers <em>must</em> 
         * do so).</p>
         *
         * @param ch the characters из_ the XML document
         * @param старт the старт позиция in the Массив
         * @param length the число of characters в_ читай из_ the Массив
         * @throws org.xml.sax.SAXException any SAX исключение, possibly
         *            wrapping другой исключение
         * @see #ignorableWhitespace 
         * @see org.xml.sax.Locator
         *******************************************************************************/
        public проц characters(Ch ch[])
        {
                
        }

        /*******************************************************************************
         * принять notification of ignorable пробел in элемент контент.
         *
         * <p>Valопрating Parsers must use this метод в_ report each чанк
         * of пробел in элемент контент (see the W3C XML 1.0
         * recommendation, section 2.10): non-validating parsers may also
         * use this метод if they are capable of parsing и using
         * контент models.</p>
         *
         * <p>SAX parsers may return все contiguous пробел in a single
         * чанк, or they may разбей it преобр_в several чанки; however, все of
         * the characters in any single событие must come из_ the same
         * external сущность, so that the Locator provопрes useful
         * information.</p>
         *
         * <p>The application must not attempt в_ читай из_ the Массив
         * outsопрe of the specified range.</p>
         *
         * @param ch the characters из_ the XML document
         * @param старт the старт позиция in the Массив
         * @param length the число of characters в_ читай из_ the Массив
         * @throws org.xml.sax.SAXException any SAX исключение, possibly
         *            wrapping другой исключение
         * @see #characters
         *******************************************************************************/
        public проц ignorableWhitespace(Ch ch[])
        {
                
        }

        /*******************************************************************************
         * принять notification of a processing instruction.
         *
         * <p>The Parser will invoke this метод once for each processing
         * instruction найдено: note that processing instructions may occur
         * before or after the main document элемент.</p>
         *
         * <p>A SAX парсер must never report an XML declaration (XML 1.0,
         * section 2.8) or a текст declaration (XML 1.0, section 4.3.1)
         * using this метод.</p>
         *
         * <p>Like {@link #characters characters()}, processing instruction
         * данные may have characters that need ещё than one <код>сим</код>
         * значение. </p>
         *
         * @param мишень the processing instruction мишень
         * @param данные the processing instruction данные, or пусто if
         *        Неук was supplied.  The данные does not include any
         *        пробел separating it из_ the мишень
         * @throws org.xml.sax.SAXException any SAX исключение, possibly
         *            wrapping другой исключение
         *******************************************************************************/
        public проц processingInstruction(Ch[] мишень, Ch[] данные)
        {
                
        }

        /*******************************************************************************
         * принять notification of a skИПped сущность.
         * This is not called for сущность references внутри markup constructs
         * such as элемент старт tags or markup declarations.  (The XML
         * recommendation требует reporting skИПped external entities.
         * SAX also reports internal сущность expansion/non-expansion, except
         * внутри markup constructs.)
         *
         * <p>The Parser will invoke this метод each время the сущность is
         * skИПped.  Non-validating processors may пропусти entities if they
         * have not seen the declarations (because, for example, the
         * сущность was declared in an external DTD поднабор).  все processors
         * may пропусти external entities, depending on the значения of the
         * <код>http://xml.org/sax/features/external-general-entities</код>
         * и the
         * <код>http://xml.org/sax/features/external-parameter-entities</код>
         * свойства.</p>
         *
         * @param имя the имя of the skИПped сущность.  If it is a 
         *        parameter сущность, the имя will begin with '%', и if
         *        it is the external DTD поднабор, it will be the ткст
         *        "[dtd]"
         * @throws org.xml.sax.SAXException any SAX исключение, possibly
         *            wrapping другой исключение
         *******************************************************************************/
        public проц skИПpedEntity(Ch[] имя)
        {
                
        }

}

/*******************************************************************************
 * Basic interface for resolving entities.
 *
 * <p>If a SAX application needs в_ implement customized handling
 * for external entities, it must implement this interface и
 * регистрируй an экземпляр with the SAX driver using the
 * {@link org.xml.sax.XMLЧитатель#setEntityResolver setEntityResolver}
 * метод.</p>
 *
 * <p>The XML читатель will then allow the application в_ intercept any
 * external entities (включая the external DTD поднабор и external
 * parameter entities, if any) before включая them.</p>
 *
 * <p>Many SAX applications will not need в_ implement this interface,
 * but it will be especially useful for applications that build
 * XML documents из_ databases or другой specialised ввод sources,
 * or for applications that use URI типы другой than URLs.</p>
 *
 * <p>The following resolver would provопрe the application
 * with a special character поток for the сущность with the system
 * определитель "http://www.myhost.com/today":</p>
 *
 * <pre>
 * import org.xml.sax.EntityResolver;
 * import org.xml.sax.InputSource;
 *
 * public class MyResolver реализует EntityResolver {
 *   public InputSource resolveEntity (Строка publicId, Строка systemId)
 *   {
 *     if (systemId.равно("http://www.myhost.com/today")) {
 *              // return a special ввод источник
 *       MyЧитатель читатель = new MyЧитатель();
 *       return new InputSource(читатель);
 *     } else {
 *              // use the default behaviour
 *       return пусто;
 *     }
 *   }
 * }
 * </pre>
 *
 * <p>The application can also use this interface в_ перенаправ system
 * определители в_ local URIs or в_ look up replacements in a каталог
 * (possibly by using the public определитель).</p>
 *
 * @since SAX 1.0
 * @author David Megginson
 * @version 2.0.1 (sax2r2)
 * @see org.xml.sax.XMLЧитатель#setEntityResolver
 * @see org.xml.sax.InputSource
 *******************************************************************************/
public interface EntityResolver(Ch = сим) {

        /*******************************************************************************
         * Разрешить the application в_ разреши external entities.
         *
         * <p>The парсер will вызов this метод before opening any external
         * сущность except the верх-уровень document сущность.  Such entities include
         * the external DTD поднабор и external parameter entities referenced
         * внутри the DTD (in either case, only if the парсер reads external
         * parameter entities), и external general entities referenced
         * внутри the document элемент (if the парсер reads external general
         * entities).  The application may request that the парсер местоположение
         * the сущность itself, that it use an alternative URI, or that it
         * use данные provопрed by the application (as a character or байт
         * ввод поток).</p>
         *
         * <p>Application writers can use this метод в_ перенаправ external
         * system определители в_ безопасно и/or local URIs, в_ look up
         * public определители in a catalogue, or в_ читай an сущность из_ a
         * database or другой ввод источник (включая, for example, a dialog
         * box).  Neither XML nor SAX specifies a preferred policy for using
         * public or system IDs в_ разреши resources.  However, SAX specifies
         * как в_ interpret any InputSource returned by this метод, и that
         * if Неук is returned, then the system ID will be dereferenced as
         * a URL.  </p>
         *
         * <p>If the system определитель is a URL, the SAX парсер must
         * разреши it fully before reporting it в_ the application.</p>
         *
         * @param publicId The public определитель of the external сущность
         *        being referenced, or пусто if Неук was supplied.
         * @param systemId The system определитель of the external сущность
         *        being referenced.
         * @return An InputSource объект describing the new ввод источник,
         *         or пусто в_ request that the парсер открой a regular
         *         URI connection в_ the system определитель.
         * @исключение org.xml.sax.SAXException Any SAX исключение, possibly
         *            wrapping другой исключение.
         * @исключение java.io.ВВИскл A Java-specific IO исключение,
         *            possibly the результат of creating a new ИПотокВвода
         *            or Читатель for the InputSource.
         * @see org.xml.sax.InputSource
         *******************************************************************************/

        public ИПотокВвода resolveEntity(Ch[] publicId, Ch[] systemId);

}

/*******************************************************************************
 * Basic interface for SAX ошибка handlers.
 *
 * <p>If a SAX application needs в_ implement customized ошибка
 * handling, it must implement this interface и then регистрируй an
 * экземпляр with the XML читатель using the
 * {@link org.xml.sax.XMLЧитатель#setErrorHandler setErrorHandler}
 * метод.  The парсер will then report все ошибки и warnings
 * through this interface.</p>
 *
 * <p><strong>WARNING:</strong> If an application does <em>not</em>
 * регистрируй an ErrorHandler, XML parsing ошибки will go unreported,
 * except that <em>SAXParseException</em>s will be thrown for фатал ошибки.
 * In order в_ detect validity ошибки, an ErrorHandler that does something
 * with {@link #ошибка ошибка()} calls must be registered.</p>
 *
 * <p>For XML processing ошибки, a SAX driver must use this interface 
 * in preference в_ throwing an исключение: it is up в_ the application 
 * в_ decопрe whether в_ throw an исключение for different типы of 
 * ошибки и warnings.  Note, however, that there is no requirement that 
 * the парсер continue в_ report добавьitional ошибки after a вызов в_ 
 * {@link #fatalError fatalError}.  In другой words, a SAX driver class 
 * may throw an исключение after reporting any fatalError.
 * Also parsers may throw appropriate exceptions for non-XML ошибки.
 * For example, {@link XMLЧитатель#разбор XMLЧитатель.разбор()} would throw
 * an ВВИскл for ошибки accessing entities or the document.</p>
 *
 * @since SAX 1.0
 * @author David Megginson
 * @version 2.0.1+ (sax2r3pre1)
 * @see org.xml.sax.XMLЧитатель#setErrorHandler
 * @see org.xml.sax.SAXParseException 
 *******************************************************************************/
public interface ErrorHandler(Ch = сим) {

        /*******************************************************************************
         * принять notification of a warning.
         *
         * <p>SAX parsers will use this метод в_ report conditions that
         * are not ошибки or фатал ошибки as defined by the XML
         * recommendation.  The default behaviour is в_ возьми no
         * action.</p>
         *
         * <p>The SAX парсер must continue в_ provопрe нормаль parsing события
         * after invoking this метод: it should still be possible for the
         * application в_ process the document through в_ the конец.</p>
         *
         * <p>Filters may use this метод в_ report другой, non-XML warnings
         * as well.</p>
         *
         * @param исключение The warning information encapsulated in a
         *                  SAX разбор исключение.
         * @исключение org.xml.sax.SAXException Any SAX исключение, possibly
         *            wrapping другой исключение.
         * @see org.xml.sax.SAXParseException 
         *******************************************************************************/
        public проц warning(SAXException исключение);

        /*******************************************************************************
         * принять notification of a recoverable ошибка.
         *
         * <p>This corresponds в_ the definition of "ошибка" in section 1.2
         * of the W3C XML 1.0 Recommendation.  For example, a validating
         * парсер would use this обрвызов в_ report the violation of a
         * validity constraint.  The default behaviour is в_ возьми no
         * action.</p>
         *
         * <p>The SAX парсер must continue в_ provопрe нормаль parsing
         * события after invoking this метод: it should still be possible
         * for the application в_ process the document through в_ the конец.
         * If the application cannot do so, then the парсер should report
         * a фатал ошибка even if the XML recommendation does not require
         * it в_ do so.</p>
         *
         * <p>Filters may use this метод в_ report другой, non-XML ошибки
         * as well.</p>
         *
         * @param исключение The ошибка information encapsulated in a
         *                  SAX разбор исключение.
         * @исключение org.xml.sax.SAXException Any SAX исключение, possibly
         *            wrapping другой исключение.
         * @see org.xml.sax.SAXParseException 
         *******************************************************************************/
        public проц ошибка(SAXException исключение);

        /*******************************************************************************
         * принять notification of a non-recoverable ошибка.
         *
         * <p><strong>There is an apparent contradiction between the
         * documentation for this метод и the documentation for {@link
         * org.xml.sax.ContentHandler#endDocument}.  Until this ambiguity
         * is resolved in a future major release, clients should сделай no
         * assumptions about whether endDocument() will or will not be
         * invoked when the парсер имеется reported a fatalError() or thrown
         * an исключение.</strong></p>
         *
         * <p>This corresponds в_ the definition of "фатал ошибка" in
         * section 1.2 of the W3C XML 1.0 Recommendation.  For example, a
         * парсер would use this обрвызов в_ report the violation of a
         * well-formedness constraint.</p>
         *
         * <p>The application must assume that the document is unusable
         * after the парсер имеется invoked this метод, и should continue
         * (if at все) only for the sake of собериing добавьitional ошибка
         * messages: in fact, SAX parsers are free в_ stop reporting any
         * другой события once this метод имеется been invoked.</p>
         *
         * @param исключение The ошибка information encapsulated in a
         *                  SAX разбор исключение.  
         * @исключение org.xml.sax.SAXException Any SAX исключение, possibly
         *            wrapping другой исключение.
         * @see org.xml.sax.SAXParseException
         *******************************************************************************/
        public проц fatalError(SAXException исключение);

}

/*******************************************************************************
 * Interface for associating a SAX событие with a document location.
 *
 * <p>If a SAX парсер provопрes location information в_ the SAX
 * application, it does so by implementing this interface и then
 * passing an экземпляр в_ the application using the контент
 * handler's {@link org.xml.sax.ContentHandler#setDocumentLocator
 * setDocumentLocator} метод.  The application can use the
 * объект в_ obtain the location of any другой SAX событие
 * in the XML источник document.</p>
 *
 * <p>Note that the results returned by the объект will be действителен only
 * during the scope of each обрвызов метод: the application
 * will принять unpredictable results if it попытки в_ use the
 * locator at any другой время, or after parsing completes.</p>
 *
 * <p>SAX parsers are not требуется в_ supply a locator, but they are
 * very strongly encouraged в_ do so.  If the парсер supplies a
 * locator, it must do so before reporting any другой document события.
 * If no locator имеется been установи by the время the application Приёмs
 * the {@link org.xml.sax.ContentHandler#startDocument startDocument}
 * событие, the application should assume that a locator is not 
 * available.</p>
 *
 * @since SAX 1.0
 * @author David Megginson
 * @version 2.0.1 (sax2r2)
 * @see org.xml.sax.ContentHandler#setDocumentLocator 
 *******************************************************************************/
public interface Locator(Ch = сим) {

        /*******************************************************************************
         * Return the public определитель for the текущ document событие.
         *
         * <p>The return значение is the public определитель of the document
         * сущность or of the external разобрано сущность in which the markup
         * triggering the событие appears.</p>
         *
         * @return A ткст containing the public определитель, or
         *         пусто if Неук is available.
         * @see #getSystemId
         *******************************************************************************/
        public Ch[] getPublicId();

        /*******************************************************************************
         * Return the system определитель for the текущ document событие.
         *
         * <p>The return значение is the system определитель of the document
         * сущность or of the external разобрано сущность in which the markup
         * triggering the событие appears.</p>
         *
         * <p>If the system определитель is a URL, the парсер must разреши it
         * fully before passing it в_ the application.  For example, a файл
         * имя must always be provопрed as a <em>файл:...</em> URL, и другой
         * kinds of relative URI are also resolved against their bases.</p>
         *
         * @return A ткст containing the system определитель, or пусто
         *         if Неук is available.
         * @see #getPublicId
         *******************************************************************************/
        public Ch[] getSystemId();

        /*******************************************************************************
         * Return the строка число where the текущ document событие заканчивается.
         * Строки are delimited by строка заканчивается, which are defined in
         * the XML specification.
         *
         * <p><strong>Предупреждение:</strong> The return значение из_ the метод
         * is intended only as an approximation for the sake of diagnostics;
         * it is not intended в_ provопрe sufficient information
         * в_ edit the character контент of the original XML document.
         * In some cases, these "строка" numbers сверь что would be displayed
         * as columns, и in другие they may not сверь the источник текст
         * due в_ internal сущность expansion.  </p>
         *
         * <p>The return значение is an approximation of the строка число
         * in the document сущность or external разобрано сущность where the
         * markup triggering the событие appears.</p>
         *
         * <p>If possible, the SAX driver should provопрe the строка позиция 
         * of the первый character after the текст associated with the document 
         * событие.  The первый строка is строка 1.</p>
         *
         * @return The строка число, or -1 if Неук is available.
         * @see #getColumnNumber
         *******************************************************************************/
        public цел getLineNumber();

        /*******************************************************************************
         * Return the column число where the текущ document событие заканчивается.
         * This is one-based число of Java <код>сим</код> значения since
         * the последний строка конец.
         *
         * <p><strong>Предупреждение:</strong> The return значение из_ the метод
         * is intended only as an approximation for the sake of diagnostics;
         * it is not intended в_ provопрe sufficient information
         * в_ edit the character контент of the original XML document.
         * For example, when строки contain combining character sequences, wide
         * characters, surrogate pairs, or bi-directional текст, the значение may
         * not correspond в_ the column in a текст editor's display. </p>
         *
         * <p>The return значение is an approximation of the column число
         * in the document сущность or external разобрано сущность where the
         * markup triggering the событие appears.</p>
         *
         * <p>If possible, the SAX driver should provопрe the строка позиция 
         * of the первый character after the текст associated with the document 
         * событие.  The первый column in each строка is column 1.</p>
         *
         * @return The column число, or -1 if Неук is available.
         * @see #getLineNumber
         *******************************************************************************/
        public цел getColumnNumber();

}


/*******************************************************************************
 * Encapsulate a general SAX ошибка or warning.
 *
 * <p>This class can contain basic ошибка or warning information из_
 * either the XML парсер or the application: a парсер писатель or
 * application писатель can subclass it в_ provопрe добавьitional
 * functionality.  SAX handlers may throw this исключение or
 * any исключение subclassed из_ it.</p>
 *
 * <p>If the application needs в_ пароль through другой типы of
 * exceptions, it must wrap those exceptions in a SAXException
 * or an исключение производный из_ a SAXException.</p>
 *
 * <p>If the парсер or application needs в_ include information about a
 * specific location in an XML document, it should use the
 * {@link org.xml.sax.SAXParseException SAXParseException} subclass.</p>
 *
 * @since SAX 1.0
 * @author David Megginson
 * @version 2.0.1 (sax2r2)
 * @see org.xml.sax.SAXParseException
 *******************************************************************************/
public class SAXException : Исключение {

        /*******************************************************************************
         * Созд a new SAXException.
         *******************************************************************************/
        public this () {
                super ("", пусто);
        }

        /*******************************************************************************
         * Созд a new SAXException.
         *
         * @param сообщение The ошибка or warning сообщение.
         *******************************************************************************/
        public this (ткст сообщение) {
                super (сообщение, пусто);
        }

        /*******************************************************************************
         * Созд a new SAXException wrapping an existing исключение.
         *
         * <p>The existing исключение will be embedded in the new
         * one, и its сообщение will become the default сообщение for
         * the SAXException.</p>
         *
         * @param e The исключение в_ be wrapped in a SAXException.
         *******************************************************************************/
        public this (Исключение e) {
                super ("", e);
        }

        /*******************************************************************************
         * Созд a new SAXException из_ an existing исключение.
         *
         * <p>The existing исключение will be embedded in the new
         * one, but the new исключение will have its own сообщение.</p>
         *
         * @param сообщение The detail сообщение.
         * @param e The исключение в_ be wrapped in a SAXException.
         *******************************************************************************/
        public this (ткст сообщение, Исключение e) {
                super (сообщение, e);
        }

        /*******************************************************************************
         * Return a detail сообщение for this исключение.
         *
         * <p>If there is an embedded исключение, и if the SAXException
         * имеется no detail сообщение of its own, this метод will return
         * the detail сообщение из_ the embedded исключение.</p>
         *
         * @return The ошибка or warning сообщение.
         *******************************************************************************/
        public ткст сообщение() {
                if (сооб is пусто && следщ !is пусто) {
                        return следщ.сооб;
                }
                else {
                        return сооб;
                }

        }

}
/*******************************************************************************
 *******************************************************************************/
class SaxParser(Ch = сим) : XMLЧитатель!(Ch), Locator!(Ch) {

        private SaxHandler!(Ch) saxHandler;
        private ErrorHandler!(Ch) errorHandler;
        private EntityResolver!(Ch) entityResolver;
        private Ch[] контент;
        private Атрибут!(Ch)[] атрибуты;
        private цел attrTop = 0;
        private бул hasStartElement = нет;
        private Ch[] startElemName;
        private PullParser!(Ch) парсер;

        /*******************************************************************************
         *******************************************************************************/
        public this() {
                атрибуты = new Атрибут!(Ch)[255];
        }

        ////////////////////////////////////////////////////////////////////
        // Configuration.
        ////////////////////////////////////////////////////////////////////
        /*******************************************************************************
         * Look up the значение of a feature флаг.
         *
         * <p>The feature имя is any fully-qualified URI.  It is
         * possible for an XMLЧитатель в_ recognize a feature имя but
         * temporarily be unable в_ return its значение.
         * Some feature значения may be available only in specific
         * contexts, such as before, during, or after a разбор.
         * Also, some feature значения may not be programmatically accessible.
         * (In the case of an адаптер for SAX1 {@link Parser}, there is no
         * implementation-independent way в_ expose whether the underlying
         * парсер is performing validation, expanding external entities,
         * и so forth.) </p>
         *
         * <p>все XMLЧитательs are требуется в_ recognize the
         * http://xml.org/sax/features/namespaces и the
         * http://xml.org/sax/features/namespace-prefixes feature names.</p>
         *
         * <p>Typical usage is something like this:</p>
         *
         * <pre>
         * XMLЧитатель r = new MySAXDriver();
         *
         *                         // try в_ activate validation
         * try {
         *   r.setFeature("http://xml.org/sax/features/validation", да);
         * } catch (SAXException e) {
         *   System.err.println("Cannot activate validation."); 
         * }
         *
         *                         // регистрируй событие handlers
         * r.setContentHandler(new MyContentHandler());
         * r.setErrorHandler(new MyErrorHandler());
         *
         *                         // разбор the первый document
         * try {
         *   r.разбор("http://www.foo.com/mydoc.xml");
         * } catch (ВВИскл e) {
         *   System.err.println("I/O исключение reading XML document");
         * } catch (SAXException e) {
         *   System.err.println("XML исключение reading document.");
         * }
         * </pre>
         *
         * <p>Implementors are free (и encouraged) в_ invent their own features,
         * using names built on their own URIs.</p>
         *
         * @param имя The feature имя, which is a fully-qualified URI.
         * @return The текущ значение of the feature (да or нет).
         * @исключение org.xml.sax.SAXNotRecognizedException If the feature
         *            значение can't be назначено or retrieved.
         * @исключение org.xml.sax.SAXNotSupportedException When the
         *            XMLЧитатель recognizes the feature имя but 
         *            cannot determine its значение at this время.
         * @see #setFeature
         *******************************************************************************/
        public бул getFeature(Ch[] имя) {
                return нет;
        }

        /*******************************************************************************
         * Набор the значение of a feature флаг.
         *
         * <p>The feature имя is any fully-qualified URI.  It is
         * possible for an XMLЧитатель в_ expose a feature значение but
         * в_ be unable в_ change the текущ значение.
         * Some feature значения may be immutable or изменяемый only 
         * in specific contexts, such as before, during, or after 
         * a разбор.</p>
         *
         * <p>все XMLЧитательs are требуется в_ support настройка
         * http://xml.org/sax/features/namespaces в_ да и
         * http://xml.org/sax/features/namespace-prefixes в_ нет.</p>
         *
         * @param имя The feature имя, which is a fully-qualified URI.
         * @param значение The requested значение of the feature (да or нет).
         * @исключение org.xml.sax.SAXNotRecognizedException If the feature
         *            значение can't be назначено or retrieved.
         * @исключение org.xml.sax.SAXNotSupportedException When the
         *            XMLЧитатель recognizes the feature имя but 
         *            cannot установи the requested значение.
         * @see #getFeature
         *******************************************************************************/
        public проц setFeature(Ch[] имя, бул значение) {

        }

        /*******************************************************************************
         * Look up the значение of a property.
         *
         * <p>The property имя is any fully-qualified URI.  It is
         * possible for an XMLЧитатель в_ recognize a property имя but
         * temporarily be unable в_ return its значение.
         * Some property значения may be available only in specific
         * contexts, such as before, during, or after a разбор.</p>
         *
         * <p>XMLЧитательs are not требуется в_ recognize any specific
         * property names, though an начальное core установи is documented for
         * SAX2.</p>
         *
         * <p>Implementors are free (и encouraged) в_ invent their own свойства,
         * using names built on their own URIs.</p>
         *
         * @param имя The property имя, which is a fully-qualified URI.
         * @return The текущ значение of the property.
         * @исключение org.xml.sax.SAXNotRecognizedException If the property
         *            значение can't be назначено or retrieved.
         * @исключение org.xml.sax.SAXNotSupportedException When the
         *            XMLЧитатель recognizes the property имя but 
         *            cannot determine its значение at this время.
         * @see #setProperty
         *******************************************************************************/
        public Объект getProperty(Ch[] имя) {
                return пусто;
        }

        /*******************************************************************************
         * Набор the значение of a property.
         *
         * <p>The property имя is any fully-qualified URI.  It is
         * possible for an XMLЧитатель в_ recognize a property имя but
         * в_ be unable в_ change the текущ значение.
         * Some property значения may be immutable or изменяемый only 
         * in specific contexts, such as before, during, or after 
         * a разбор.</p>
         *
         * <p>XMLЧитательs are not требуется в_ recognize настройка
         * any specific property names, though a core установи is defined by 
         * SAX2.</p>
         *
         * <p>This метод is also the стандарт mechanism for настройка
         * extended handlers.</p>
         *
         * @param имя The property имя, which is a fully-qualified URI.
         * @param значение The requested значение for the property.
         * @исключение org.xml.sax.SAXNotRecognizedException If the property
         *            значение can't be назначено or retrieved.
         * @исключение org.xml.sax.SAXNotSupportedException When the
         *            XMLЧитатель recognizes the property имя but 
         *            cannot установи the requested значение.
         *******************************************************************************/
        public проц setProperty(Ch[] имя, Объект значение) {

        }

        ////////////////////////////////////////////////////////////////////
        // Событие handlers.
        ////////////////////////////////////////////////////////////////////
        /*******************************************************************************
         * Разрешить an application в_ регистрируй an сущность resolver.
         *
         * <p>If the application does not регистрируй an сущность resolver,
         * the XMLЧитатель will perform its own default resolution.</p>
         *
         * <p>Applications may регистрируй a new or different resolver in the
         * mопрdle of a разбор, и the SAX парсер must begin using the new
         * resolver immediately.</p>
         *
         * @param resolver The сущность resolver.
         * @see #getEntityResolver
         *******************************************************************************/
        public проц setEntityResolver(EntityResolver!(Ch) resolver) {
                entityResolver = resolver;
        }

        /*******************************************************************************
         * Return the текущ сущность resolver.
         *
         * @return The текущ сущность resolver, or пусто if Неук
         *         имеется been registered.
         * @see #setEntityResolver
         *******************************************************************************/
        public EntityResolver!(Ch) getEntityResolver() {
                return entityResolver;
        }

        /*******************************************************************************
         * Разрешить an application в_ регистрируй a контент событие handler.
         *
         * <p>If the application does not регистрируй a контент handler, все
         * контент события reported by the SAX парсер will be silently
         * ignored.</p>
         *
         * <p>Applications may регистрируй a new or different handler in the
         * mопрdle of a разбор, и the SAX парсер must begin using the new
         * handler immediately.</p>
         *
         * @param handler The контент handler.
         * @see #getContentHandler
         *******************************************************************************/
        public проц setSaxHandler(SaxHandler!(Ch) handler) {
                saxHandler = handler;
        }

        /*******************************************************************************
         * Return the текущ контент handler.
         *
         * @return The текущ контент handler, or пусто if Неук
         *         имеется been registered.
         * @see #setContentHandler
         *******************************************************************************/
        public SaxHandler!(Ch) getSaxHandler() {
                return saxHandler;
        }

        /*******************************************************************************
         * Разрешить an application в_ регистрируй an ошибка событие handler.
         *
         * <p>If the application does not регистрируй an ошибка handler, все
         * ошибка события reported by the SAX парсер will be silently
         * ignored; however, нормаль processing may not continue.  It is
         * highly recommended that все SAX applications implement an
         * ошибка handler в_ avoопр неожиданный bugs.</p>
         *
         * <p>Applications may регистрируй a new or different handler in the
         * mопрdle of a разбор, и the SAX парсер must begin using the new
         * handler immediately.</p>
         *
         * @param handler The ошибка handler.
         * @see #getErrorHandler
         *******************************************************************************/
        public проц setErrorHandler(ErrorHandler!(Ch) handler) {
                errorHandler = handler;
        }

        /*******************************************************************************
         * Return the текущ ошибка handler.
         *
         * @return The текущ ошибка handler, or пусто if Неук
         *         имеется been registered.
         * @see #setErrorHandler
         *******************************************************************************/
        public ErrorHandler!(Ch) getErrorHandler() {
                return errorHandler;
        }

        ////////////////////////////////////////////////////////////////////
        // Parsing.
        ////////////////////////////////////////////////////////////////////
        /*******************************************************************************
         * Parse an XML document.
         *
         * <p>The application can use this метод в_ instruct the XML
         * читатель в_ begin parsing an XML document из_ any действителен ввод
         * источник (a character поток, a байт поток, or a URI).</p>
         *
         * <p>Applications may not invoke this метод while a разбор is in
         * ход (they should создай a new XMLЧитатель instead for each
         * nested XML document).  Once a разбор is complete, an
         * application may reuse the same XMLЧитатель объект, possibly with a
         * different ввод источник.
         * Configuration of the XMLЧитатель объект (such as handler привязки и
         * значения established for feature флаги и свойства) is unchanged
         * by completion of a разбор, unless the definition of that aspect of
         * the configuration explicitly specifies другой behavior.
         * (For example, feature флаги or свойства exposing
         * characteristics of the document being разобрано.)
         * </p>
         *
         * <p>During the разбор, the XMLЧитатель will provопрe information
         * about the XML document through the registered событие
         * handlers.</p>
         *
         * <p>This метод is синхронно: it will not return until parsing
         * имеется ended.  If a клиент application wants в_ терминируй 
         * parsing early, it should throw an исключение.</p>
         *
         * @param ввод The ввод источник for the верх-уровень of the
         *        XML document.
         * @исключение org.xml.sax.SAXException Any SAX исключение, possibly
         *            wrapping другой исключение.
         * @исключение java.io.ВВИскл An IO исключение из_ the парсер,
         *            possibly из_ a байт поток or character поток
         *            supplied by the application.
         * @see org.xml.sax.InputSource
         * @see #разбор(java.lang.Строка)
         * @see #setEntityResolver
         * @see #setContentHandler
         * @see #setErrorHandler 
         *******************************************************************************/
        private проц разбор(ИПотокВвода ввод) {
                //TODO turn преобр_в a Ch[] буфер
                doParse();
        }

        /*******************************************************************************
         * Parse an XML document из_ a system определитель (URI).
         *
         * <p>This метод is a shortcut for the common case of reading a
         * document из_ a system определитель.  It is the exact
         * equivalent of the following:</p>
         *
         * <pre>
         * разбор(new InputSource(systemId));
         * </pre>
         *
         * <p>If the system определитель is a URL, it must be fully resolved
         * by the application before it is passed в_ the парсер.</p>
         *
         * @param systemId The system определитель (URI).
         * @исключение org.xml.sax.SAXException Any SAX исключение, possibly
         *            wrapping другой исключение.
         * @исключение java.io.ВВИскл An IO исключение из_ the парсер,
         *            possibly из_ a байт поток or character поток
         *            supplied by the application.
         * @see #разбор(org.xml.sax.InputSource)
         *******************************************************************************/
        private проц parseUrl(Ch[] systemId) {
                //TODO turn url преобр_в a Ch[] буфер            
                doParse();
        }

        /*******************************************************************************
         * Parse an XML document из_ a character Массив.
         *
         * @param контент The actual document контент.
         * @исключение org.xml.sax.SAXException Any SAX исключение, possibly
         *            wrapping другой исключение.
         * @исключение java.io.ВВИскл An IO исключение из_ the парсер,
         *            possibly из_ a байт поток or character поток
         *            supplied by the application.
         * @see #разбор(org.xml.sax.InputSource)
         *******************************************************************************/
        public проц разбор(Ch[] контент) {
	        this.устКонтент(контент);
                doParse();
        }

        /*******************************************************************************
         *******************************************************************************/
        public проц разбор() {
                doParse();
        }

        /*******************************************************************************
         *******************************************************************************/
        public проц устКонтент(Ch[] контент) {
	        if (!парсер) {
                        парсер = new PullParser!(Ch)(контент);
		} else {
		        парсер.сбрось(контент);
		}
        }

        /*******************************************************************************
         *******************************************************************************/
        public проц сбрось() {
                парсер.сбрось();
        }

        /*******************************************************************************
         *         The meat of the class.  Turn the pull парсер's узелs преобр_в SAX
         *         события и шли out в_ the SaxHandler.
         *******************************************************************************/
        private проц doParse() {
                saxHandler.setDocumentLocator(this);
                saxHandler.startDocument();
                while (да) {
                        switch (парсер.следщ) {
                        case ПТипТокенаРЯР.НачальныйЭлемент :
                                if (hasStartElement) {
                                        saxHandler.startElement(пусто, startElemName, пусто, атрибуты[0..attrTop]);
                                        hasStartElement = нет;
                                        attrTop = 0;
                                }               
                                startElemName = парсер.localName;
                                hasStartElement = да;
                                break;
                        case ПТипТокенаРЯР.Атрибут :
                                атрибуты[attrTop].localName = парсер.localName;
                                атрибуты[attrTop].значение = парсер.НеобрValue;
                                attrTop++;
                                break;
                        case ПТипТокенаРЯР.КонечныйЭлемент :
                        case ПТипТокенаРЯР.ПустойКонечныйЭлемент :
                                if (hasStartElement) {
                                        saxHandler.startElement(пусто, startElemName, пусто, атрибуты[0..attrTop]);
                                        hasStartElement = нет;
                                        attrTop = 0;
                                }               
                                saxHandler.endElement(пусто, парсер.localName, пусто);
                                break;
                        case ПТипТокенаРЯР.Данные :
                                if (hasStartElement) {
                                        saxHandler.startElement(пусто, startElemName, пусто, атрибуты[0..attrTop]);
                                        hasStartElement = нет;
                                        attrTop = 0;
                                }               
                                saxHandler.characters(парсер.НеобрValue);
                                break;
                        case ПТипТокенаРЯР.Комментарий :
                        case ПТипТокенаРЯР.СиДанные :
                        case ПТипТокенаРЯР.Доктип :
                        case ПТипТокенаРЯР.ПИ :
                        case ПТипТокенаРЯР.Нет :
                                if (hasStartElement) {
                                        saxHandler.startElement(пусто, startElemName, пусто, атрибуты[0..attrTop]);
                                        hasStartElement = нет;
                                        attrTop = 0;
                                }               
                                break;

                        case ПТипТокенаРЯР.Готово:
                             goto foo;

                        default:
                                throw new SAXException("неизвестное парсер токен тип");
                        }
                } 
foo:                              
                saxHandler.endDocument();
        }

        /*******************************************************************************
         * Return the public определитель for the текущ document событие.
         *
         * <p>The return значение is the public определитель of the document
         * сущность or of the external разобрано сущность in which the markup
         * triggering the событие appears.</p>
         *
         * @return A ткст containing the public определитель, or
         *         пусто if Неук is available.
         * @see #getSystemId
         *******************************************************************************/
        public Ch[] getPublicId() {
                return пусто;
        }

        /*******************************************************************************
         * Return the system определитель for the текущ document событие.
         *
         * <p>The return значение is the system определитель of the document
         * сущность or of the external разобрано сущность in which the markup
         * triggering the событие appears.</p>
         *
         * <p>If the system определитель is a URL, the парсер must разреши it
         * fully before passing it в_ the application.  For example, a файл
         * имя must always be provопрed as a <em>файл:...</em> URL, и другой
         * kinds of relative URI are also resolved against their bases.</p>
         *
         * @return A ткст containing the system определитель, or пусто
         *         if Неук is available.
         * @see #getPublicId
         *******************************************************************************/
        public Ch[] getSystemId() {
                return пусто;  
        }

        /*******************************************************************************
         * Return the строка число where the текущ document событие заканчивается.
         * Строки are delimited by строка заканчивается, which are defined in
         * the XML specification.
         *
         * <p><strong>Предупреждение:</strong> The return значение из_ the метод
         * is intended only as an approximation for the sake of diagnostics;
         * it is not intended в_ provопрe sufficient information
         * в_ edit the character контент of the original XML document.
         * In some cases, these "строка" numbers сверь что would be displayed
         * as columns, и in другие they may not сверь the источник текст
         * due в_ internal сущность expansion.  </p>
         *
         * <p>The return значение is an approximation of the строка число
         * in the document сущность or external разобрано сущность where the
         * markup triggering the событие appears.</p>
         *
         * <p>If possible, the SAX driver should provопрe the строка позиция 
         * of the первый character after the текст associated with the document 
         * событие.  The первый строка is строка 1.</p>
         *
         * @return The строка число, or -1 if Неук is available.
         * @see #getColumnNumber
         *******************************************************************************/
        public цел getLineNumber() {
                return 0;
        }

        /*******************************************************************************
         * Return the column число where the текущ document событие заканчивается.
         * This is one-based число of Java <код>сим</код> значения since
         * the последний строка конец.
         *
         * <p><strong>Предупреждение:</strong> The return значение из_ the метод
         * is intended only as an approximation for the sake of diagnostics;
         * it is not intended в_ provопрe sufficient information
         * в_ edit the character контент of the original XML document.
         * For example, when строки contain combining character sequences, wide
         * characters, surrogate pairs, or bi-directional текст, the значение may
         * not correspond в_ the column in a текст editor's display. </p>
         *
         * <p>The return значение is an approximation of the column число
         * in the document сущность or external разобрано сущность where the
         * markup triggering the событие appears.</p>
         *
         * <p>If possible, the SAX driver should provопрe the строка позиция 
         * of the первый character after the текст associated with the document 
         * событие.  The первый column in each строка is column 1.</p>
         *
         * @return The column число, or -1 if Неук is available.
         * @see #getLineNumber
         *******************************************************************************/
        public цел getColumnNumber() {
                return 0;
        }


}


/*******************************************************************************
 * Interface for an XML фильтр.
 *
 * <p>An XML фильтр is like an XML читатель, except that it obtains its
 * события из_ другой XML читатель rather than a primary источник like
 * an XML document or database.  Filters can modify a поток of
 * события as they пароль on в_ the final application.</p>
 *
 * <p>The XMLFilterImpl helper class provопрes a convenient основа
 * for creating SAX2 filters, by passing on все {@link org.xml.sax.EntityResolver
 * EntityResolver}, {@link org.xml.sax.DTDHandler DTDHandler},
 * {@link org.xml.sax.ContentHandler ContentHandler} и {@link org.xml.sax.ErrorHandler
 * ErrorHandler} события automatically.</p>
 *
 * @since SAX 2.0
 * @author David Megginson
 * @version 2.0.1 (sax2r2)
 * @see org.xml.sax.helpers.XMLFilterImpl
 *******************************************************************************/
public abstract class XMLFilter(Ch = сим) : XMLЧитатель {

        /*******************************************************************************
         * Набор the предок читатель.
         *
         * <p>This метод allows the application в_ link the фильтр в_
         * a предок читатель (which may be другой фильтр).  The аргумент
         * may not be пусто.</p>
         *
         * @param предок The предок читатель.
         *******************************************************************************/
        public проц setParent(XMLЧитатель предок){
                //do nothing
        }

        /*******************************************************************************
         * Get the предок читатель.
         *
         * <p>This метод allows the application в_ запрос the предок
         * читатель (which may be другой фильтр).  It is generally a
         * bad опрea в_ perform any operations on the предок читатель
         * directly: they should все пароль through this фильтр.</p>
         *
         * @return The предок фильтр, or пусто if Неук имеется been установи.
         *******************************************************************************/
        public XMLЧитатель getParent() {
                return пусто;
        }

}

/*******************************************************************************
 * База class for deriving an XML фильтр.
 *
 * <p>This class is designed в_ sit between an {@link org.xml.sax.XMLЧитатель
 * XMLЧитатель} и the клиент application's событие handlers.  By default, it
 * does nothing but пароль requests up в_ the читатель и события
 * on в_ the handlers unmodified, but subclasses can override
 * specific methods в_ modify the событие поток or the configuration
 * requests as they пароль through.</p>
 *
 * @since SAX 2.0
 * @author David Megginson
 * @version 2.0.1 (sax2r2)
 * @see org.xml.sax.XMLFilter
 * @see org.xml.sax.XMLЧитатель
 * @see org.xml.sax.EntityResolver
 * @see org.xml.sax.ContentHandler
 * @see org.xml.sax.ErrorHandler
 *******************************************************************************/
public class XMLFilterImpl(Ch = сим) : SaxHandler, XMLFilter, EntityResolver, ErrorHandler {

        ////////////////////////////////////////////////////////////////////
        // Constructors.
        ////////////////////////////////////////////////////////////////////
        /*******************************************************************************
         * Construct an пустой XML фильтр, with no предок.
         *
         * <p>This фильтр will have no предок: you must присвой a предок
         * before you старт a разбор or do any configuration with
         * setFeature or setProperty, unless you use this as a pure событие
         * consumer rather than as an {@link XMLЧитатель}.</p>
         *
         * @see org.xml.sax.XMLЧитатель#setFeature
         * @see org.xml.sax.XMLЧитатель#setProperty
         * @see #setParent
         *******************************************************************************/
        public this () {

        }

        /*******************************************************************************
         * Construct an XML фильтр with the specified предок.
         *
         * @see #setParent
         * @see #getParent
         *******************************************************************************/
        public this (XMLЧитатель предок) {
                setParent(предок);
        }

        ////////////////////////////////////////////////////////////////////
        // Implementation of org.xml.sax.XMLFilter.
        ////////////////////////////////////////////////////////////////////
        /*******************************************************************************
         * Набор the предок читатель.
         *
         * <p>This is the {@link org.xml.sax.XMLЧитатель XMLЧитатель} из_ which 
         * this фильтр will obtain its события и в_ which it will пароль its 
         * configuration requests.  The предок may itself be другой фильтр.</p>
         *
         * <p>If there is no предок читатель установи, any attempt в_ разбор
         * or в_ установи or получи a feature or property will краш.</p>
         *
         * @param предок The предок XML читатель.
         * @see #getParent
         *******************************************************************************/
        public проц setParent(XMLЧитатель предок) {
                this.предок = предок;
        }

        /*******************************************************************************
         * Get the предок читатель.
         *
         * @return The предок XML читатель, or пусто if Неук is установи.
         * @see #setParent
         *******************************************************************************/
        public XMLЧитатель getParent() {
                return предок;
        }

        ////////////////////////////////////////////////////////////////////
        // Implementation of org.xml.sax.XMLЧитатель.
        ////////////////////////////////////////////////////////////////////
        /*******************************************************************************
         * Набор the значение of a feature.
         *
         * <p>This will always краш if the предок is пусто.</p>
         *
         * @param имя The feature имя.
         * @param значение The requested feature значение.
         * @исключение org.xml.sax.SAXNotRecognizedException If the feature
         *            значение can't be назначено or retrieved из_ the предок.
         * @исключение org.xml.sax.SAXNotSupportedException When the
         *            предок recognizes the feature имя but 
         *            cannot установи the requested значение.
         *******************************************************************************/
        public проц setFeature(Ch[] имя, бул значение) {
                if (предок !is пусто) {
                        предок.setFeature(имя, значение);
                }
                else {
                        throw new SAXException("Feature not recognized: " ~ имя);
                }

        }

        /*******************************************************************************
         * Look up the значение of a feature.
         *
         * <p>This will always краш if the предок is пусто.</p>
         *
         * @param имя The feature имя.
         * @return The текущ значение of the feature.
         * @исключение org.xml.sax.SAXNotRecognizedException If the feature
         *            значение can't be назначено or retrieved из_ the предок.
         * @исключение org.xml.sax.SAXNotSupportedException When the
         *            предок recognizes the feature имя but 
         *            cannot determine its значение at this время.
         *******************************************************************************/
        public бул getFeature(Ch[] имя) {
                if (предок !is пусто) {
                        return предок.getFeature(имя);
                }
                else {
                        throw new SAXException("Feature not recognized: " ~ имя);
                }

        }

        /*******************************************************************************
         * Набор the значение of a property.
         *
         * <p>This will always краш if the предок is пусто.</p>
         *
         * @param имя The property имя.
         * @param значение The requested property значение.
         * @исключение org.xml.sax.SAXNotRecognizedException If the property
         *            значение can't be назначено or retrieved из_ the предок.
         * @исключение org.xml.sax.SAXNotSupportedException When the
         *            предок recognizes the property имя but 
         *            cannot установи the requested значение.
         *******************************************************************************/
        public проц setProperty(Ch[] имя, Объект значение) {
                if (предок !is пусто) {
                        предок.setProperty(имя, значение);
                }
                else {
                        throw new SAXException("Property not recognized: " ~ имя);
                }

        }

        /*******************************************************************************
         * Look up the значение of a property.
         *
         * @param имя The property имя.
         * @return The текущ значение of the property.
         * @исключение org.xml.sax.SAXNotRecognizedException If the property
         *            значение can't be назначено or retrieved из_ the предок.
         * @исключение org.xml.sax.SAXNotSupportedException When the
         *            предок recognizes the property имя but 
         *            cannot determine its значение at this время.
         *******************************************************************************/
        public Объект getProperty(Ch[] имя) {
                if (предок !is пусто) {
                        return предок.getProperty(имя);
                }
                else {
                        throw new SAXException("Property not recognized: " ~ имя);
                }

        }

        /*******************************************************************************
         * Набор the сущность resolver.
         *
         * @param resolver The new сущность resolver.
         *******************************************************************************/
        public проц setEntityResolver(EntityResolver resolver) {
                entityResolver = resolver;
        }

        /**
         * Get the текущ сущность resolver.
         *
         * @return The текущ сущность resolver, or пусто if Неук was установи.
         *******************************************************************************/
        public EntityResolver getEntityResolver() {
                return entityResolver;
        }

        /*******************************************************************************
         * Набор the контент событие handler.
         *
         * @param handler the new контент handler
         *******************************************************************************/
        public проц setSaxHandler(SaxHandler handler) {
                saxHandler = handler;
        }

        /*******************************************************************************
         * Get the контент событие handler.
         *
         * @return The текущ контент handler, or пусто if Неук was установи.
         *******************************************************************************/
        public SaxHandler getSaxHandler() {
                return saxHandler;
        }

        /*******************************************************************************
         * Набор the ошибка событие handler.
         *
         * @param handler the new ошибка handler
         *******************************************************************************/
        public проц setErrorHandler(ErrorHandler handler) {
                errorHandler = handler;
        }

        /*******************************************************************************
         * Get the текущ ошибка событие handler.
         *
         * @return The текущ ошибка handler, or пусто if Неук was установи.
         *******************************************************************************/
        public ErrorHandler getErrorHandler() {
                return errorHandler;
        }

        /*******************************************************************************
         * Parse a document.
         *
         * @param ввод The ввод источник for the document сущность.
         * @исключение org.xml.sax.SAXException Any SAX исключение, possibly
         *            wrapping другой исключение.
         * @исключение java.io.ВВИскл An IO исключение из_ the парсер,
         *            possibly из_ a байт поток or character поток
         *            supplied by the application.
         *******************************************************************************/
        private проц разбор(ИПотокВвода ввод) {
                setupParse();
                предок.разбор(ввод);
        }

        /*******************************************************************************
         * Parse the given контент.
         *
         * @param ввод The ввод источник for the document сущность.
         * @исключение org.xml.sax.SAXException Any SAX исключение, possibly
         *            wrapping другой исключение.
         * @исключение java.io.ВВИскл An IO исключение из_ the парсер,
         *            possibly из_ a байт поток or character поток
         *            supplied by the application.
         *******************************************************************************/
        public проц разбор(Ch[] контент) {
                //TODO FIXME - создай a буфер of this контент as the ввод поток, и then разбор.
                //setupParse();
                //предок.разбор(ввод);
        }

        public проц разбор() {}
        public проц устКонтент(Ch[] контент) {}


        /*******************************************************************************
         * Parse a document.
         *
         * @param systemId The system определитель as a fully-qualified URI.
         * @исключение org.xml.sax.SAXException Any SAX исключение, possibly
         *            wrapping другой исключение.
         * @исключение java.io.ВВИскл An IO исключение из_ the парсер,
         *            possibly из_ a байт поток or character поток
         *            supplied by the application.
         *******************************************************************************/
        private проц parseUrl(Ch[] systemId) {
                //TODO FIXME
                //разбор(new InputSource(systemId));
        }

        ////////////////////////////////////////////////////////////////////
        // Implementation of org.xml.sax.EntityResolver.
        ////////////////////////////////////////////////////////////////////
        /*******************************************************************************
         * Фильтр an external сущность resolution.
         *
         * @param publicId The сущность's public определитель, or пусто.
         * @param systemId The сущность's system определитель.
         * @return A new InputSource or пусто for the default.
         * @исключение org.xml.sax.SAXException The клиент may throw
         *            an исключение during processing.
         * @исключение java.io.ВВИскл The клиент may throw an
         *            I/O-related исключение while obtaining the
         *            new InputSource.
         *******************************************************************************/
        public ИПотокВвода resolveEntity(Ch[] publicId, Ch[] systemId) {
                if (entityResolver !is пусто) {
                        return entityResolver.resolveEntity(publicId, systemId);
                }
                else {
                        return пусто;
                }

        }

        ////////////////////////////////////////////////////////////////////
        // Implementation of org.xml.sax.ContentHandler.
        ////////////////////////////////////////////////////////////////////
        /*******************************************************************************
         * Фильтр a new document locator событие.
         *
         * @param locator The document locator.
         *******************************************************************************/
        public проц setDocumentLocator(Locator locator) {
                this.locator = locator;
                if (saxHandler !is пусто) {
                        saxHandler.setDocumentLocator(locator);
                }

        }

        /*******************************************************************************
         * Фильтр a старт document событие.
         *
         * @исключение org.xml.sax.SAXException The клиент may throw
         *            an исключение during processing.
         *******************************************************************************/
        public проц startDocument() {
                if (saxHandler !is пусто) {
                        saxHandler.startDocument();
                }

        }

        /*******************************************************************************
         * Фильтр an конец document событие.
         *
         * @исключение org.xml.sax.SAXException The клиент may throw
         *            an исключение during processing.
         *******************************************************************************/
        public проц endDocument() {
                if (saxHandler !is пусто) {
                        saxHandler.endDocument();
                }

        }

        /*******************************************************************************
         * Фильтр a старт Namespace префикс маппинг событие.
         *
         * @param префикс The Namespace префикс.
         * @param уир The Namespace URI.
         * @исключение org.xml.sax.SAXException The клиент may throw
         *            an исключение during processing.
         *******************************************************************************/
        public проц startPrefixMapping(Ch[] префикс, Ch[] уир) {
                if (saxHandler !is пусто) {
                        saxHandler.startPrefixMapping(префикс, уир);
                }

        }

        /*******************************************************************************
         * Фильтр an конец Namespace префикс маппинг событие.
         *
         * @param префикс The Namespace префикс.
         * @исключение org.xml.sax.SAXException The клиент may throw
         *            an исключение during processing.
         *******************************************************************************/
        public проц endPrefixMapping(Ch[] префикс) {
                if (saxHandler !is пусто) {
                        saxHandler.endPrefixMapping(префикс);
                }

        }

        /*******************************************************************************
         * Фильтр a старт элемент событие.
         *
         * @param уир The элемент's Namespace URI, or the пустой ткст.
         * @param localName The элемент's local имя, or the пустой ткст.
         * @param qName The элемент's qualified (псеп_в_начале) имя, or the пустой
         *        ткст.
         * @param atts The элемент's атрибуты.
         * @исключение org.xml.sax.SAXException The клиент may throw
         *            an исключение during processing.
         *******************************************************************************/
        public проц startElement(Ch[] уир, Ch[] localName, Ch[] qName, Атрибут[] atts) {
                if (saxHandler !is пусто) {
                        saxHandler.startElement(уир, localName, qName, atts);
                }    

        }

        /*******************************************************************************
         * Фильтр an конец элемент событие.
         *
         * @param уир The элемент's Namespace URI, or the пустой ткст.
         * @param localName The элемент's local имя, or the пустой ткст.
         * @param qName The элемент's qualified (псеп_в_начале) имя, or the пустой
         *        ткст.
         * @исключение org.xml.sax.SAXException The клиент may throw
         *            an исключение during processing.
         *******************************************************************************/
        public проц endElement(Ch[] уир, Ch[] localName, Ch[] qName) {
                if (saxHandler !is пусто) {
                        saxHandler.endElement(уир, localName, qName);
                }

        }

        /*******************************************************************************
         * Фильтр a character данные событие.
         *
         * @param ch An Массив of characters.
         * @исключение org.xml.sax.SAXException The клиент may throw
         *            an исключение during processing.
         *******************************************************************************/
        public проц characters(Ch ch[]) {
                if (saxHandler !is пусто) {
                        saxHandler.characters(ch);
                }

        }

        /*******************************************************************************
         * Фильтр an ignorable пробел событие.
         *
         * @param ch An Массив of characters.
         * @param старт The starting позиция in the Массив.
         * @param length The число of characters в_ use из_ the Массив.
         * @исключение org.xml.sax.SAXException The клиент may throw
         *            an исключение during processing.
         *******************************************************************************/
        public проц ignorableWhitespace(Ch ch[]) {
                if (saxHandler !is пусто) {
                        saxHandler.ignorableWhitespace(ch);
                }

        }

        /*******************************************************************************
         * Фильтр a processing instruction событие.
         *
         * @param мишень The processing instruction мишень.
         * @param данные The текст following the мишень.
         * @исключение org.xml.sax.SAXException The клиент may throw
         *            an исключение during processing.
         *******************************************************************************/
        public проц processingInstruction(Ch[] мишень, Ch[] данные) {
                if (saxHandler !is пусто) {
                        saxHandler.processingInstruction(мишень, данные);
                }

        }

        /*******************************************************************************
         * Фильтр a skИПped сущность событие.
         *
         * @param имя The имя of the skИПped сущность.
         * @исключение org.xml.sax.SAXException The клиент may throw
         *            an исключение during processing.
         *******************************************************************************/
        public проц skИПpedEntity(Ch[] имя) {
                if (saxHandler !is пусто) {
                        saxHandler.skИПpedEntity(имя);
                }

        }

        ////////////////////////////////////////////////////////////////////
        // Implementation of org.xml.sax.ErrorHandler.
        ////////////////////////////////////////////////////////////////////
        /*******************************************************************************
         * Фильтр a warning событие.
         *
         * @param e The warning as an исключение.
         * @исключение org.xml.sax.SAXException The клиент may throw
         *            an исключение during processing.
         *******************************************************************************/
        public проц warning(SAXException e) {
                if (errorHandler !is пусто) {
                        errorHandler.warning(e);
                }

        }

        /*******************************************************************************
         * Фильтр an ошибка событие.
         *
         * @param e The ошибка as an исключение.
         * @исключение org.xml.sax.SAXException The клиент may throw
         *            an исключение during processing.
         *******************************************************************************/
        public проц ошибка(SAXException e) {
                if (errorHandler !is пусто) {
                        errorHandler.ошибка(e);
                }

        }

        /*******************************************************************************
         * Фильтр a фатал ошибка событие.
         *
         * @param e The ошибка as an исключение.
         * @исключение org.xml.sax.SAXException The клиент may throw
         *            an исключение during processing.
         *******************************************************************************/
        public проц fatalError(SAXException e) {
                if (errorHandler !is пусто) {
                        errorHandler.fatalError(e);
                }

        }

        ////////////////////////////////////////////////////////////////////
        // Internal methods.
        ////////////////////////////////////////////////////////////////////
        /*******************************************************************************
         * Набор up before a разбор.
         *
         * <p>Before every разбор, проверь whether the предок is
         * non-пусто, и re-регистрируй the фильтр for все of the 
         * события.</p>
         *******************************************************************************/
        private проц setupParse() {
                if (предок is пусто) {
                        throw new Исключение("No предок for фильтр");
                }
                предок.setEntityResolver(this);
                предок.setSaxHandler(this);
                предок.setErrorHandler(this);
        }

        ////////////////////////////////////////////////////////////////////
        // Internal состояние.
        ////////////////////////////////////////////////////////////////////
        private XMLЧитатель предок = пусто;

        private Locator locator = пусто;

        private EntityResolver entityResolver = пусто;

        private SaxHandler saxHandler = пусто;

        private ErrorHandler errorHandler = пусто;

}



/*******************************************************************************
 * Interface for reading an XML document using обрвызовы.
 *
 * <p>XMLЧитатель is the interface that an XML парсер's SAX2 driver must
 * implement.  This interface allows an application в_ установи и
 * запрос features и свойства in the парсер, в_ регистрируй
 * событие handlers for document processing, и в_ initiate
 * a document разбор.</p>
 *
 * <p>все SAX interfaces are assumed в_ be синхронно: the
 * {@link #разбор разбор} methods must not return until parsing
 * is complete, и readers must жди for an событие-handler обрвызов
 * в_ return before reporting the следщ событие.</p>
 *
 * <p>This interface replaces the (сейчас deprecated) SAX 1.0 {@link
 * org.xml.sax.Parser Parser} interface.  The XMLЧитатель interface
 * содержит two important enhancements over the old Parser
 * interface (as well as some minor ones):</p>
 *
 * <ol>
 * <li>it добавьs a стандарт way в_ запрос и установи features и 
 *  свойства; и</li>
 * <li>it добавьs Namespace support, which is требуется for many
 *  higher-уровень XML standards.</li>
 * </ol>
 *
 * <p>There are adapters available в_ преобразуй a SAX1 Parser в_
 * a SAX2 XMLЧитатель и vice-versa.</p>
 *
 * @since SAX 2.0
 * @author David Megginson
 * @version 2.0.1+ (sax2r3pre1)
 * @see org.xml.sax.XMLFilter
 * @see org.xml.sax.helpers.ParserAdapter
 * @see org.xml.sax.helpers.XMLЧитательAdapter 
 *******************************************************************************/
public interface XMLЧитатель(Ch = сим) {

        ////////////////////////////////////////////////////////////////////
        // Configuration.
        ////////////////////////////////////////////////////////////////////
        /*******************************************************************************
         * Look up the значение of a feature флаг.
         *
         * <p>The feature имя is any fully-qualified URI.  It is
         * possible for an XMLЧитатель в_ recognize a feature имя but
         * temporarily be unable в_ return its значение.
         * Some feature значения may be available only in specific
         * contexts, such as before, during, or after a разбор.
         * Also, some feature значения may not be programmatically accessible.
         * (In the case of an адаптер for SAX1 {@link Parser}, there is no
         * implementation-independent way в_ expose whether the underlying
         * парсер is performing validation, expanding external entities,
         * и so forth.) </p>
         *
         * <p>все XMLЧитательs are требуется в_ recognize the
         * http://xml.org/sax/features/namespaces и the
         * http://xml.org/sax/features/namespace-prefixes feature names.</p>
         *
         * <p>Typical usage is something like this:</p>
         *
         * <pre>
         * XMLЧитатель r = new MySAXDriver();
         *
         *                         // try в_ activate validation
         * try {
         *   r.setFeature("http://xml.org/sax/features/validation", да);
         * } catch (SAXException e) {
         *   System.err.println("Cannot activate validation."); 
         * }
         *
         *                         // регистрируй событие handlers
         * r.setContentHandler(new MyContentHandler());
         * r.setErrorHandler(new MyErrorHandler());
         *
         *                         // разбор the первый document
         * try {
         *   r.разбор("http://www.foo.com/mydoc.xml");
         * } catch (ВВИскл e) {
         *   System.err.println("I/O исключение reading XML document");
         * } catch (SAXException e) {
         *   System.err.println("XML исключение reading document.");
         * }
         * </pre>
         *
         * <p>Implementors are free (и encouraged) в_ invent their own features,
         * using names built on their own URIs.</p>
         *
         * @param имя The feature имя, which is a fully-qualified URI.
         * @return The текущ значение of the feature (да or нет).
         * @исключение org.xml.sax.SAXNotRecognizedException If the feature
         *            значение can't be назначено or retrieved.
         * @исключение org.xml.sax.SAXNotSupportedException When the
         *            XMLЧитатель recognizes the feature имя but 
         *            cannot determine its значение at this время.
         * @see #setFeature
         *******************************************************************************/
        public бул getFeature(Ch[] имя);

        /*******************************************************************************
         * Набор the значение of a feature флаг.
         *
         * <p>The feature имя is any fully-qualified URI.  It is
         * possible for an XMLЧитатель в_ expose a feature значение but
         * в_ be unable в_ change the текущ значение.
         * Some feature значения may be immutable or изменяемый only 
         * in specific contexts, such as before, during, or after 
         * a разбор.</p>
         *
         * <p>все XMLЧитательs are требуется в_ support настройка
         * http://xml.org/sax/features/namespaces в_ да и
         * http://xml.org/sax/features/namespace-prefixes в_ нет.</p>
         *
         * @param имя The feature имя, which is a fully-qualified URI.
         * @param значение The requested значение of the feature (да or нет).
         * @исключение org.xml.sax.SAXNotRecognizedException If the feature
         *            значение can't be назначено or retrieved.
         * @исключение org.xml.sax.SAXNotSupportedException When the
         *            XMLЧитатель recognizes the feature имя but 
         *            cannot установи the requested значение.
         * @see #getFeature
         *******************************************************************************/
        public проц setFeature(Ch[] имя, бул значение);

        /*******************************************************************************
         * Look up the значение of a property.
         *
         * <p>The property имя is any fully-qualified URI.  It is
         * possible for an XMLЧитатель в_ recognize a property имя but
         * temporarily be unable в_ return its значение.
         * Some property значения may be available only in specific
         * contexts, such as before, during, or after a разбор.</p>
         *
         * <p>XMLЧитательs are not требуется в_ recognize any specific
         * property names, though an начальное core установи is documented for
         * SAX2.</p>
         *
         * <p>Implementors are free (и encouraged) в_ invent their own свойства,
         * using names built on their own URIs.</p>
         *
         * @param имя The property имя, which is a fully-qualified URI.
         * @return The текущ значение of the property.
         * @исключение org.xml.sax.SAXNotRecognizedException If the property
         *            значение can't be назначено or retrieved.
         * @исключение org.xml.sax.SAXNotSupportedException When the
         *            XMLЧитатель recognizes the property имя but 
         *            cannot determine its значение at this время.
         * @see #setProperty
         *******************************************************************************/
        public Объект getProperty(Ch[] имя);

        /*******************************************************************************
         * Набор the значение of a property.
         *
         * <p>The property имя is any fully-qualified URI.  It is
         * possible for an XMLЧитатель в_ recognize a property имя but
         * в_ be unable в_ change the текущ значение.
         * Some property значения may be immutable or изменяемый only 
         * in specific contexts, such as before, during, or after 
         * a разбор.</p>
         *
         * <p>XMLЧитательs are not требуется в_ recognize настройка
         * any specific property names, though a core установи is defined by 
         * SAX2.</p>
         *
         * <p>This метод is also the стандарт mechanism for настройка
         * extended handlers.</p>
         *
         * @param имя The property имя, which is a fully-qualified URI.
         * @param значение The requested значение for the property.
         * @исключение org.xml.sax.SAXNotRecognizedException If the property
         *            значение can't be назначено or retrieved.
         * @исключение org.xml.sax.SAXNotSupportedException When the
         *            XMLЧитатель recognizes the property имя but 
         *            cannot установи the requested значение.
         *******************************************************************************/
        public проц setProperty(Ch[] имя, Объект значение);

        ////////////////////////////////////////////////////////////////////
        // Событие handlers.
        ////////////////////////////////////////////////////////////////////
        /*******************************************************************************
         * Разрешить an application в_ регистрируй an сущность resolver.
         *
         * <p>If the application does not регистрируй an сущность resolver,
         * the XMLЧитатель will perform its own default resolution.</p>
         *
         * <p>Applications may регистрируй a new or different resolver in the
         * mопрdle of a разбор, и the SAX парсер must begin using the new
         * resolver immediately.</p>
         *
         * @param resolver The сущность resolver.
         * @see #getEntityResolver
         *******************************************************************************/
        public проц setEntityResolver(EntityResolver!(Ch) resolver);

        /*******************************************************************************
         * Return the текущ сущность resolver.
         *
         * @return The текущ сущность resolver, or пусто if Неук
         *         имеется been registered.
         * @see #setEntityResolver
         *******************************************************************************/
        public EntityResolver!(Ch) getEntityResolver();

        /*******************************************************************************
         * Разрешить an application в_ регистрируй a контент событие handler.
         *
         * <p>If the application does not регистрируй a контент handler, все
         * контент события reported by the SAX парсер will be silently
         * ignored.</p>
         *
         * <p>Applications may регистрируй a new or different handler in the
         * mопрdle of a разбор, и the SAX парсер must begin using the new
         * handler immediately.</p>
         *
         * @param handler The контент handler.
         * @see #getContentHandler
         *******************************************************************************/
        public проц setSaxHandler(SaxHandler!(Ch) handler);

        /*******************************************************************************
         * Return the текущ контент handler.
         *
         * @return The текущ контент handler, or пусто if Неук
         *         имеется been registered.
         * @see #setContentHandler
         *******************************************************************************/
        public SaxHandler!(Ch) getSaxHandler();

        /*******************************************************************************
         * Разрешить an application в_ регистрируй an ошибка событие handler.
         *
         * <p>If the application does not регистрируй an ошибка handler, все
         * ошибка события reported by the SAX парсер will be silently
         * ignored; however, нормаль processing may not continue.  It is
         * highly recommended that все SAX applications implement an
         * ошибка handler в_ avoопр неожиданный bugs.</p>
         *
         * <p>Applications may регистрируй a new or different handler in the
         * mопрdle of a разбор, и the SAX парсер must begin using the new
         * handler immediately.</p>
         *
         * @param handler The ошибка handler.
         * @see #getErrorHandler
         *******************************************************************************/
        public проц setErrorHandler(ErrorHandler!(Ch) handler);

        /*******************************************************************************
         * Return the текущ ошибка handler.
         *
         * @return The текущ ошибка handler, or пусто if Неук
         *         имеется been registered.
         * @see #setErrorHandler
         *******************************************************************************/
        public ErrorHandler!(Ch) getErrorHandler();

        ////////////////////////////////////////////////////////////////////
        // Parsing.
        ////////////////////////////////////////////////////////////////////
        /*******************************************************************************
         * Parse an XML document.
         *
         * <p>The application can use this метод в_ instruct the XML
         * читатель в_ begin parsing an XML document из_ any действителен ввод
         * источник (a character поток, a байт поток, or a URI).</p>
         *
         * <p>Applications may not invoke this метод while a разбор is in
         * ход (they should создай a new XMLЧитатель instead for each
         * nested XML document).  Once a разбор is complete, an
         * application may reuse the same XMLЧитатель объект, possibly with a
         * different ввод источник.
         * Configuration of the XMLЧитатель объект (such as handler привязки и
         * значения established for feature флаги и свойства) is unchanged
         * by completion of a разбор, unless the definition of that aspect of
         * the configuration explicitly specifies другой behavior.
         * (For example, feature флаги or свойства exposing
         * characteristics of the document being разобрано.)
         * </p>
         *
         * <p>During the разбор, the XMLЧитатель will provопрe information
         * about the XML document through the registered событие
         * handlers.</p>
         *
         * <p>This метод is синхронно: it will not return until parsing
         * имеется ended.  If a клиент application wants в_ терминируй 
         * parsing early, it should throw an исключение.</p>
         *
         * @param ввод The ввод источник for the верх-уровень of the
         *        XML document.
         * @исключение org.xml.sax.SAXException Any SAX исключение, possibly
         *            wrapping другой исключение.
         * @исключение java.io.ВВИскл An IO исключение из_ the парсер,
         *            possibly из_ a байт поток or character поток
         *            supplied by the application.
         * @see org.xml.sax.InputSource
         * @see #разбор(java.lang.Строка)
         * @see #setEntityResolver
         * @see #setContentHandler
         * @see #setErrorHandler 
         *******************************************************************************/
        private проц разбор(ИПотокВвода ввод);

        /*******************************************************************************
         * Parse an XML document из_ a system определитель (URI).
         *
         * <p>This метод is a shortcut for the common case of reading a
         * document из_ a system определитель.  It is the exact
         * equivalent of the following:</p>
         *
         * <pre>
         * разбор(new InputSource(systemId));
         * </pre>
         *
         * <p>If the system определитель is a URL, it must be fully resolved
         * by the application before it is passed в_ the парсер.</p>
         *
         * @param systemId The system определитель (URI).
         * @исключение org.xml.sax.SAXException Any SAX исключение, possibly
         *            wrapping другой исключение.
         * @исключение java.io.ВВИскл An IO исключение из_ the парсер,
         *            possibly из_ a байт поток or character поток
         *            supplied by the application.
         * @see #разбор(org.xml.sax.InputSource)
         *******************************************************************************/
        private проц parseUrl(Ch[] systemId);

        /*******************************************************************************
         * Parse an XML document из_ a character Массив.
         *
         * @param контент The actual document контент.
         * @исключение org.xml.sax.SAXException Any SAX исключение, possibly
         *            wrapping другой исключение.
         * @исключение java.io.ВВИскл An IO исключение из_ the парсер,
         *            possibly из_ a байт поток or character поток
         *            supplied by the application.
         * @see #разбор(org.xml.sax.InputSource)
         *******************************************************************************/
        public проц разбор(Ch[] контент);

        /*******************************************************************************
         *******************************************************************************/
        public проц разбор();

        /*******************************************************************************
         *******************************************************************************/
        public проц устКонтент(Ch[] контент);

}
