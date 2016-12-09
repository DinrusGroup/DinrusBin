module std.bind;

public import tpl.bind;

alias ДинАрг  DynArg;
alias динАрг_ли isDynArg;
alias ТипДинМас DynamicArrayType;
alias _присвой _assign;
alias Кортеж Tuple;
alias кортеж tuple;
alias типКортеж_ли isTypeTuple;
alias минЧлоАргов minNumArgs;
alias СФункцСвязки MBoundFunc;

version (BindUseStruct)
 {

alias ДерефФункц DerefFunc;
alias СвязаннаяФункц BoundFunc;
}

alias  привяжи bind;
alias привяжиАлиас bindAlias;
alias функцСвязки_ли isBoundFunc;
alias ЧисловыеТипы NumericTypes;
alias типыДинАргов dynArgTypes;
alias  макЦел maxInt;
alias члоДинАргов numDynArgs;
alias ПустойСлот  EmptySlot;
alias дайТипыДинАргов  getDynArgTypes;
alias ИзвлечённыеСвязанныеАрги ExtractedBoundArgs ;
alias извлекиСвязанныеАрги extractBoundArgs;
alias дайДлинуАрга  getArgLen;
alias СодержитТипПустойСлот ContainsEmptySlotType;
alias  АлиасПусто NullAlias;
alias КортежМетодовПередачиПараметров ParamsPassMethodTuple;
alias СсылПарамыФункцВВидеУков  FuncReferenceParamsAsPointers;
alias КортежУказателей PointerTuple;
alias примениУк ptrApply;
