// Microsoft Office Runtime 1.0 Type Library
// Version 1.0

/*[uuid("b35fbde9-7042-11d3-9c0f-00c04f72dd5f")]*/
module os.win.tlb.msorunlib;

/*[importlib("STDOLE2.TLB")]*/
private import os.win.com.core;

// Interfaces

// IIEHTMLElementCollection Interface
interface IIEHTMLElementCollection : IDispatch {
  mixin(uuid("de5f419b-9e04-11d3-a4a0-00c04f6843fb"));
  /*[id(0x00000002)]*/ int get_length(out int pLength);
  /*[id(0x00000003)]*/ int item(VARIANT varName, VARIANT varIndex, out IDispatch ppDisp);
}

// IIETimeBehaviorFactory Interface
interface IIETimeBehaviorFactory : IUnknown {
  mixin(uuid("a4639d28-774e-11d3-a490-00c04f6843fb"));
}

// IIEAnimBehaviorFactory Interface
interface IIEAnimBehaviorFactory : IUnknown {
  mixin(uuid("a4639d2e-774e-11d3-a490-00c04f6843fb"));
}

// ITimeExecutiveBehavior Interface
interface ITimeExecutiveBehavior : IDispatch {
  mixin(uuid("a4639d32-774e-11d3-a490-00c04f6843fb"));
  /*[id(0x00000002)]*/ int put_localTime(VARIANT pvarLocalTime);
  /*[id(0x00000002)]*/ int get_localTime(out VARIANT pvarLocalTime);
  /*[id(0x00000003)]*/ int start();
  /*[id(0x00000004)]*/ int stop();
  /*[id(0x00000005)]*/ int pause();
  /*[id(0x00000006)]*/ int resume();
  /*[id(0x00000007)]*/ int pptPrev();
  /*[id(0x00000008)]*/ int pptNext();
  /*[id(0x00000009)]*/ int calculateAutoAdvanceTimes(double slideTime, IDispatch pArrayDisp, out double pSlideTime);
  /*[id(0x0000000A)]*/ int get_playAnimations(out VARIANT pvarPlayAnimations);
}

// ITimeExecutiveBehaviorInternal Interface
interface ITimeExecutiveBehaviorInternal : IUnknown {
  mixin(uuid("c8f6cc4c-8711-11d3-a496-00c04f6843fb"));
  /*[id(0x60010000)]*/ int GetTimeExecutive(out VARIANT pvarTE);
  /*[id(0x60010001)]*/ int GetTimeExecutiveHolder(out VARIANT pvarTEH);
}

// IAnimExecutiveBehavior Interface
interface IAnimExecutiveBehavior : IDispatch {
  mixin(uuid("a4639d3e-774e-11d3-a490-00c04f6843fb"));
}

// IAnimExecutiveBehaviorInternal Interface
interface IAnimExecutiveBehaviorInternal : IUnknown {
  mixin(uuid("c0b8dc28-8c89-11d3-a499-00c04f6843fb"));
  /*[id(0x60010000)]*/ int GetTrackManager(out VARIANT pvarTM);
  /*[id(0x60010001)]*/ int AttachToTimeExecutive();
}

// IAnimateDHTMLBehavior Interface
interface IAnimateDHTMLBehavior : IDispatch {
  mixin(uuid("816ca827-8be4-11d3-a498-00c04f6843fb"));
  /*[id(0x0000000A)]*/ int put_calcmode(VARIANT pvarCalcMode);
  /*[id(0x0000000A)]*/ int get_calcmode(out VARIANT pvarCalcMode);
  /*[id(0x0000000B)]*/ int put_values(VARIANT pvarValues);
  /*[id(0x0000000B)]*/ int get_values(out VARIANT pvarValues);
  /*[id(0x0000000C)]*/ int put_keyTimes(VARIANT pvarKeyTimes);
  /*[id(0x0000000C)]*/ int get_keyTimes(out VARIANT pvarKeyTimes);
  /*[id(0x0000000D)]*/ int put_formulas(VARIANT pvarFormulas);
  /*[id(0x0000000D)]*/ int get_formulas(out VARIANT pvarFormulas);
  /*[id(0x00000002)]*/ int put_additive(VARIANT pvarAdditive);
  /*[id(0x00000002)]*/ int get_additive(out VARIANT pvarAdditive);
  /*[id(0x00000003)]*/ int put_accumulate(VARIANT pvarAccumulate);
  /*[id(0x00000003)]*/ int get_accumulate(out VARIANT pvarAccumulate);
  /*[id(0x00000004)]*/ int put_attributeName(VARIANT pvarAttributeName);
  /*[id(0x00000004)]*/ int get_attributeName(out VARIANT pvarAttributeName);
  /*[id(0x00000005)]*/ int put_valueType(VARIANT pvarValueType);
  /*[id(0x00000005)]*/ int get_valueType(out VARIANT pvarValueType);
  /*[id(0x00000006)]*/ int put_targetElement(VARIANT pvarTarget);
  /*[id(0x00000006)]*/ int get_targetElement(out VARIANT pvarTarget);
  /*[id(0x00000008)]*/ int put_from(VARIANT pvarFrom);
  /*[id(0x00000008)]*/ int get_from(out VARIANT pvarFrom);
  /*[id(0x00000009)]*/ int put_to(VARIANT pvarTo);
  /*[id(0x00000009)]*/ int get_to(out VARIANT pvarTo);
  /*[id(0x00000007)]*/ int put_by(VARIANT pvarBy);
  /*[id(0x00000007)]*/ int get_by(out VARIANT pvarBy);
  /*[id(0x0000000E)]*/ int put_runtimeContext(VARIANT pvarContext);
  /*[id(0x0000000E)]*/ int get_runtimeContext(out VARIANT pvarContext);
  /*[id(0x0000000F)]*/ int get_animatedParent(out VARIANT pvarParent);
}

// IAnimTargetDHTMLBehaviorInternal Interface
interface IAnimTargetDHTMLBehaviorInternal : IUnknown {
  mixin(uuid("3234f33a-918c-11d3-a49e-00c04f6843fb"));
  /*[id(0x60010000)]*/ int GetAnimElementReference(out VARIANT pvarAnimElemRef);
}

// IAnimColorDHTMLBehavior Interface
interface IAnimColorDHTMLBehavior : IDispatch {
  mixin(uuid("816ca824-8be4-11d3-a498-00c04f6843fb"));
  /*[id(0x00000002)]*/ int put_colorSpace(VARIANT pvarColorSpace);
  /*[id(0x00000002)]*/ int get_colorSpace(out VARIANT pvarColorSpace);
  /*[id(0x00000003)]*/ int put_direction(VARIANT pvarDirection);
  /*[id(0x00000003)]*/ int get_direction(out VARIANT pvarDirection);
  /*[id(0x00000004)]*/ int put_accumulate(VARIANT pvarAccumulate);
  /*[id(0x00000004)]*/ int get_accumulate(out VARIANT pvarAccumulate);
  /*[id(0x00000005)]*/ int put_attributeName(VARIANT pvarAttributeName);
  /*[id(0x00000005)]*/ int get_attributeName(out VARIANT pvarAttributeName);
  /*[id(0x00000006)]*/ int put_targetElement(VARIANT pvarTarget);
  /*[id(0x00000006)]*/ int get_targetElement(out VARIANT pvarTarget);
  /*[id(0x00000008)]*/ int put_from(VARIANT pvarFrom);
  /*[id(0x00000008)]*/ int get_from(out VARIANT pvarFrom);
  /*[id(0x00000009)]*/ int put_to(VARIANT pvarTo);
  /*[id(0x00000009)]*/ int get_to(out VARIANT pvarTo);
  /*[id(0x00000007)]*/ int put_by(VARIANT pvarBy);
  /*[id(0x00000007)]*/ int get_by(out VARIANT pvarBy);
  /*[id(0x0000000A)]*/ int put_calcmode(VARIANT pvarCalcMode);
  /*[id(0x0000000A)]*/ int get_calcmode(out VARIANT pvarCalcMode);
  /*[id(0x0000000B)]*/ int put_runtimeContext(VARIANT pvarContext);
  /*[id(0x0000000B)]*/ int get_runtimeContext(out VARIANT pvarContext);
  /*[id(0x0000000C)]*/ int get_animatedParent(out VARIANT pvarParent);
}

// IAnimFilterDHTMLBehavior Interface
interface IAnimFilterDHTMLBehavior : IDispatch {
  mixin(uuid("816ca829-8be4-11d3-a498-00c04f6843fb"));
  /*[id(0x00000003)]*/ int put_targetElement(VARIANT pvarTarget);
  /*[id(0x00000003)]*/ int get_targetElement(out VARIANT pvarTarget);
  /*[id(0x00000004)]*/ int put_transition(VARIANT pvarTransition);
  /*[id(0x00000004)]*/ int get_transition(out VARIANT pvarTransition);
  /*[id(0x00000005)]*/ int put_propertyList(VARIANT pvarPropertyList);
  /*[id(0x00000005)]*/ int get_propertyList(out VARIANT pvarPropertyList);
  /*[id(0x00000006)]*/ int put_progress(VARIANT pvarProgress);
  /*[id(0x00000006)]*/ int get_progress(out VARIANT pvarProgress);
  /*[id(0x00000007)]*/ int put_filter(VARIANT pvarType);
  /*[id(0x00000007)]*/ int get_filter(out VARIANT pvarType);
  /*[id(0x00000008)]*/ int put_runtimeContext(VARIANT pvarContext);
  /*[id(0x00000008)]*/ int get_runtimeContext(out VARIANT pvarContext);
  /*[id(0x00000009)]*/ int get_animatedParent(out VARIANT pvarParent);
}

// IAnimMotionDHTMLBehavior Interface
interface IAnimMotionDHTMLBehavior : IDispatch {
  mixin(uuid("816ca82b-8be4-11d3-a498-00c04f6843fb"));
  /*[id(0x00000002)]*/ int put_additive(VARIANT pvarAdditive);
  /*[id(0x00000002)]*/ int get_additive(out VARIANT pvarAdditive);
  /*[id(0x00000003)]*/ int put_accumulate(VARIANT pvarAccumulate);
  /*[id(0x00000003)]*/ int get_accumulate(out VARIANT pvarAccumulate);
  /*[id(0x00000004)]*/ int put_attributeName(VARIANT pvarAttributeName);
  /*[id(0x00000004)]*/ int get_attributeName(out VARIANT pvarAttributeName);
  /*[id(0x00000005)]*/ int put_targetElement(VARIANT pvarTarget);
  /*[id(0x00000005)]*/ int get_targetElement(out VARIANT pvarTarget);
  /*[id(0x00000007)]*/ int put_from(VARIANT pvarFrom);
  /*[id(0x00000007)]*/ int get_from(out VARIANT pvarFrom);
  /*[id(0x00000008)]*/ int put_to(VARIANT pvarTo);
  /*[id(0x00000008)]*/ int get_to(out VARIANT pvarTo);
  /*[id(0x00000006)]*/ int put_by(VARIANT pvarBy);
  /*[id(0x00000006)]*/ int get_by(out VARIANT pvarBy);
  /*[id(0x00000009)]*/ int put_origin(VARIANT pvarOrigin);
  /*[id(0x00000009)]*/ int get_origin(out VARIANT pvarOrigin);
  /*[id(0x0000000A)]*/ int put_path(VARIANT pvarPath);
  /*[id(0x0000000A)]*/ int get_path(out VARIANT pvarPath);
  /*[id(0x0000000C)]*/ int put_calcmode(VARIANT pvarCalcMode);
  /*[id(0x0000000C)]*/ int get_calcmode(out VARIANT pvarCalcMode);
  /*[id(0x0000000D)]*/ int put_runtimeContext(VARIANT pvarContext);
  /*[id(0x0000000D)]*/ int get_runtimeContext(out VARIANT pvarContext);
  /*[id(0x0000000B)]*/ int get_animatedParent(out VARIANT pvarParent);
}

// IAnimRotationDHTMLBehavior Interface
interface IAnimRotationDHTMLBehavior : IDispatch {
  mixin(uuid("816ca82d-8be4-11d3-a498-00c04f6843fb"));
  /*[id(0x00000002)]*/ int put_additive(VARIANT pvarAdditive);
  /*[id(0x00000002)]*/ int get_additive(out VARIANT pvarAdditive);
  /*[id(0x00000003)]*/ int put_accumulate(VARIANT pvarAccumulate);
  /*[id(0x00000003)]*/ int get_accumulate(out VARIANT pvarAccumulate);
  /*[id(0x00000004)]*/ int put_attributeName(VARIANT pvarAttributeName);
  /*[id(0x00000004)]*/ int get_attributeName(out VARIANT pvarAttributeName);
  /*[id(0x00000005)]*/ int put_targetElement(VARIANT pvarTarget);
  /*[id(0x00000005)]*/ int get_targetElement(out VARIANT pvarTarget);
  /*[id(0x00000007)]*/ int put_from(VARIANT pvarFrom);
  /*[id(0x00000007)]*/ int get_from(out VARIANT pvarFrom);
  /*[id(0x00000008)]*/ int put_to(VARIANT pvarTo);
  /*[id(0x00000008)]*/ int get_to(out VARIANT pvarTo);
  /*[id(0x00000006)]*/ int put_by(VARIANT pvarBy);
  /*[id(0x00000006)]*/ int get_by(out VARIANT pvarBy);
  /*[id(0x00000009)]*/ int put_transformType(VARIANT pvarTransformType);
  /*[id(0x00000009)]*/ int get_transformType(out VARIANT pvarTransformType);
  /*[id(0x0000000A)]*/ int put_direction(VARIANT pvarDirection);
  /*[id(0x0000000A)]*/ int get_direction(out VARIANT pvarDirection);
  /*[id(0x0000000B)]*/ int put_calcmode(VARIANT pvarCalcMode);
  /*[id(0x0000000B)]*/ int get_calcmode(out VARIANT pvarCalcMode);
  /*[id(0x0000000C)]*/ int put_runtimeContext(VARIANT pvarContext);
  /*[id(0x0000000C)]*/ int get_runtimeContext(out VARIANT pvarContext);
  /*[id(0x0000000D)]*/ int get_animatedParent(out VARIANT pvarParent);
}

// IAnimScaleDHTMLBehavior Interface
interface IAnimScaleDHTMLBehavior : IDispatch {
  mixin(uuid("816ca82f-8be4-11d3-a498-00c04f6843fb"));
  /*[id(0x00000002)]*/ int put_additive(VARIANT pvarAdditive);
  /*[id(0x00000002)]*/ int get_additive(out VARIANT pvarAdditive);
  /*[id(0x00000003)]*/ int put_accumulate(VARIANT pvarAccumulate);
  /*[id(0x00000003)]*/ int get_accumulate(out VARIANT pvarAccumulate);
  /*[id(0x00000004)]*/ int put_targetElement(VARIANT pvarTarget);
  /*[id(0x00000004)]*/ int get_targetElement(out VARIANT pvarTarget);
  /*[id(0x00000006)]*/ int put_from(VARIANT pvarFrom);
  /*[id(0x00000006)]*/ int get_from(out VARIANT pvarFrom);
  /*[id(0x00000007)]*/ int put_to(VARIANT pvarTo);
  /*[id(0x00000007)]*/ int get_to(out VARIANT pvarTo);
  /*[id(0x00000005)]*/ int put_by(VARIANT pvarBy);
  /*[id(0x00000005)]*/ int get_by(out VARIANT pvarBy);
  /*[id(0x00000008)]*/ int put_transformType(VARIANT pvarTransformType);
  /*[id(0x00000008)]*/ int get_transformType(out VARIANT pvarTransformType);
  /*[id(0x00000009)]*/ int put_zoomContents(VARIANT pvarZoomContents);
  /*[id(0x00000009)]*/ int get_zoomContents(out VARIANT pvarZoomContents);
  /*[id(0x0000000A)]*/ int put_calcmode(VARIANT pvarCalcMode);
  /*[id(0x0000000A)]*/ int get_calcmode(out VARIANT pvarCalcMode);
  /*[id(0x0000000B)]*/ int put_runtimeContext(VARIANT pvarContext);
  /*[id(0x0000000B)]*/ int get_runtimeContext(out VARIANT pvarContext);
  /*[id(0x0000000C)]*/ int get_animatedParent(out VARIANT pvarParent);
}

// IAnimSetDHTMLBehavior Interface
interface IAnimSetDHTMLBehavior : IDispatch {
  mixin(uuid("816ca831-8be4-11d3-a498-00c04f6843fb"));
  /*[id(0x00000002)]*/ int put_additive(VARIANT pvarAdditive);
  /*[id(0x00000002)]*/ int get_additive(out VARIANT pvarAdditive);
  /*[id(0x00000003)]*/ int put_accumulate(VARIANT pvarAccumulate);
  /*[id(0x00000003)]*/ int get_accumulate(out VARIANT pvarAccumulate);
  /*[id(0x00000004)]*/ int put_attributeName(VARIANT pvarAttributeName);
  /*[id(0x00000004)]*/ int get_attributeName(out VARIANT pvarAttributeName);
  /*[id(0x00000005)]*/ int put_valueType(VARIANT pvarValueType);
  /*[id(0x00000005)]*/ int get_valueType(out VARIANT pvarValueType);
  /*[id(0x00000006)]*/ int put_targetElement(VARIANT pvarTarget);
  /*[id(0x00000006)]*/ int get_targetElement(out VARIANT pvarTarget);
  /*[id(0x00000007)]*/ int put_to(VARIANT pvarTo);
  /*[id(0x00000007)]*/ int get_to(out VARIANT pvarTo);
  /*[id(0x00000008)]*/ int put_runtimeContext(VARIANT pvarContext);
  /*[id(0x00000008)]*/ int get_runtimeContext(out VARIANT pvarContext);
  /*[id(0x00000009)]*/ int get_animatedParent(out VARIANT pvarParent);
}

// IAnimTargetDHTMLBehavior Interface
interface IAnimTargetDHTMLBehavior : IDispatch {
  mixin(uuid("df2efcb4-917a-11d3-a49e-00c04f6843fb"));
}

// ITimeDHTMLBehavior Interface
interface ITimeDHTMLBehavior : IDispatch {
  mixin(uuid("a4639d40-774e-11d3-a490-00c04f6843fb"));
  /*[id(0x00000002)]*/ int put_begin(VARIANT pvarBegin);
  /*[id(0x00000002)]*/ int get_begin(out VARIANT pvarBegin);
  /*[id(0x00000003)]*/ int put_end(VARIANT pvarEnd);
  /*[id(0x00000003)]*/ int get_end(out VARIANT pvarEnd);
  /*[id(0x00000004)]*/ int put_dur(VARIANT pvarDur);
  /*[id(0x00000004)]*/ int get_dur(out VARIANT pvarDur);
  /*[id(0x00000005)]*/ int put_repeatCount(VARIANT pvarRepeatCount);
  /*[id(0x00000005)]*/ int get_repeatCount(out VARIANT pvarRepeatCount);
  /*[id(0x00000006)]*/ int put_repeatDur(VARIANT pvarRepeatDur);
  /*[id(0x00000006)]*/ int get_repeatDur(out VARIANT pvarRepeatDur);
  /*[id(0x00000007)]*/ int put_restart(VARIANT pvarRestart);
  /*[id(0x00000007)]*/ int get_restart(out VARIANT pvarRestart);
  /*[id(0x00000008)]*/ int put_fill(VARIANT pvarFill);
  /*[id(0x00000008)]*/ int get_fill(out VARIANT pvarFill);
  /*[id(0x00000009)]*/ int put_speed(VARIANT pvarSpeed);
  /*[id(0x00000009)]*/ int get_speed(out VARIANT pvarSpeed);
  /*[id(0x0000000A)]*/ int put_accelerate(VARIANT pvarAccelerate);
  /*[id(0x0000000A)]*/ int get_accelerate(out VARIANT pvarAccelerate);
  /*[id(0x0000000B)]*/ int put_decelerate(VARIANT pvarDecelerate);
  /*[id(0x0000000B)]*/ int get_decelerate(out VARIANT pvarDecelerate);
  /*[id(0x0000000C)]*/ int put_autoReverse(VARIANT pvarAutoReverse);
  /*[id(0x0000000C)]*/ int get_autoReverse(out VARIANT pvarAutoReverse);
  /*[id(0x0000000D)]*/ int put_syncBehavior(VARIANT pvarSyncBehavior);
  /*[id(0x0000000D)]*/ int get_syncBehavior(out VARIANT pvarSyncBehavior);
  /*[id(0x0000000E)]*/ int put_syncTolerance(VARIANT pvarSyncTolerance);
  /*[id(0x0000000E)]*/ int get_syncTolerance(out VARIANT pvarSyncTolerance);
  /*[id(0x0000000F)]*/ int put_syncMaster(VARIANT pvarSyncMaster);
  /*[id(0x0000000F)]*/ int get_syncMaster(out VARIANT pvarSyncMaster);
  /*[id(0x00000010)]*/ int put_endSync(VARIANT pvarSync);
  /*[id(0x00000010)]*/ int get_endSync(out VARIANT pvarSync);
  /*[id(0x00000011)]*/ int put_eventFilter(VARIANT pvarEventFilter);
  /*[id(0x00000011)]*/ int get_eventFilter(out VARIANT pvarEventFilter);
  /*[id(0x00000012)]*/ int put_timeFilter(VARIANT pvarTimeFilter);
  /*[id(0x00000012)]*/ int get_timeFilter(out VARIANT pvarTimeFilter);
  /*[id(0x00000013)]*/ int put_timeContainer(VARIANT pvarTimeContainer);
  /*[id(0x00000013)]*/ int get_timeContainer(out VARIANT pvarTimeContainer);
  /*[id(0x00000014)]*/ int put_timeAction(VARIANT pvarTimeAction);
  /*[id(0x00000014)]*/ int get_timeAction(out VARIANT pvarTimeAction);
  /*[id(0x00000015)]*/ int put_endHold(VARIANT pvarEndHold);
  /*[id(0x00000015)]*/ int get_endHold(out VARIANT pvarEndHold);
  /*[id(0x00000016)]*/ int put_repeat(VARIANT pvarRepeat);
  /*[id(0x00000016)]*/ int get_repeat(out VARIANT pvarRepeat);
  /*[id(0x00000018)]*/ int put_localTime(VARIANT pvarLocalTime);
  /*[id(0x00000018)]*/ int get_localTime(out VARIANT pvarLocalTime);
  /*[id(0x00000019)]*/ int get_timedParent(out VARIANT pvarTimedParent);
  /*[id(0x0000001A)]*/ int get_timedChildren(out VARIANT pvarTimedChildren);
  /*[id(0x0000001B)]*/ int beginElement(VARIANT varOffset);
  /*[id(0x0000001C)]*/ int endElement(VARIANT varOffset);
  /*[id(0x0000001D)]*/ int pauseElement();
  /*[id(0x0000001E)]*/ int resumeElement();
  /*[id(0x0000001F)]*/ int next();
  /*[id(0x00000020)]*/ int previous();
  /*[id(0x00000021)]*/ int get_canGoNext(out VARIANT pvarCanGoNext);
  /*[id(0x00000022)]*/ int get_canGoPrev(out VARIANT pvarCanGoPrev);
}

// ITimeDHTMLBehaviorInternal Interface
interface ITimeDHTMLBehaviorInternal : IUnknown {
  mixin(uuid("70f3057a-8684-11d3-a496-00c04f6843fb"));
  /*[id(0x60010000)]*/ int GetBehaviorSite(out VARIANT pvarSite);
}

// IIterateDHTMLBehavior Interface
interface IIterateDHTMLBehavior : IDispatch {
  mixin(uuid("b96f84f6-d5ab-11d3-a4ca-00c04f6843fb"));
  /*[id(0x00000002)]*/ int put_begin(VARIANT pvarBegin);
  /*[id(0x00000002)]*/ int get_begin(out VARIANT pvarBegin);
  /*[id(0x00000003)]*/ int put_end(VARIANT pvarEnd);
  /*[id(0x00000003)]*/ int get_end(out VARIANT pvarEnd);
  /*[id(0x00000004)]*/ int put_dur(VARIANT pvarDur);
  /*[id(0x00000004)]*/ int get_dur(out VARIANT pvarDur);
  /*[id(0x00000005)]*/ int put_repeatCount(VARIANT pvarRepeatCount);
  /*[id(0x00000005)]*/ int get_repeatCount(out VARIANT pvarRepeatCount);
  /*[id(0x00000006)]*/ int put_repeatDur(VARIANT pvarRepeatDur);
  /*[id(0x00000006)]*/ int get_repeatDur(out VARIANT pvarRepeatDur);
  /*[id(0x00000007)]*/ int put_restart(VARIANT pvarRestart);
  /*[id(0x00000007)]*/ int get_restart(out VARIANT pvarRestart);
  /*[id(0x00000008)]*/ int put_fill(VARIANT pvarFill);
  /*[id(0x00000008)]*/ int get_fill(out VARIANT pvarFill);
  /*[id(0x00000009)]*/ int put_speed(VARIANT pvarSpeed);
  /*[id(0x00000009)]*/ int get_speed(out VARIANT pvarSpeed);
  /*[id(0x0000000A)]*/ int put_accelerate(VARIANT pvarAccelerate);
  /*[id(0x0000000A)]*/ int get_accelerate(out VARIANT pvarAccelerate);
  /*[id(0x0000000B)]*/ int put_decelerate(VARIANT pvarDecelerate);
  /*[id(0x0000000B)]*/ int get_decelerate(out VARIANT pvarDecelerate);
  /*[id(0x0000000C)]*/ int put_autoReverse(VARIANT pvarAutoReverse);
  /*[id(0x0000000C)]*/ int get_autoReverse(out VARIANT pvarAutoReverse);
  /*[id(0x0000000D)]*/ int put_syncBehavior(VARIANT pvarSyncBehavior);
  /*[id(0x0000000D)]*/ int get_syncBehavior(out VARIANT pvarSyncBehavior);
  /*[id(0x0000000E)]*/ int put_syncTolerance(VARIANT pvarSyncTolerance);
  /*[id(0x0000000E)]*/ int get_syncTolerance(out VARIANT pvarSyncTolerance);
  /*[id(0x0000000F)]*/ int put_syncMaster(VARIANT pvarSyncMaster);
  /*[id(0x0000000F)]*/ int get_syncMaster(out VARIANT pvarSyncMaster);
  /*[id(0x00000010)]*/ int put_endSync(VARIANT pvarSync);
  /*[id(0x00000010)]*/ int get_endSync(out VARIANT pvarSync);
  /*[id(0x00000011)]*/ int put_eventFilter(VARIANT pvarEventFilter);
  /*[id(0x00000011)]*/ int get_eventFilter(out VARIANT pvarEventFilter);
  /*[id(0x00000012)]*/ int put_timeFilter(VARIANT pvarTimeFilter);
  /*[id(0x00000012)]*/ int get_timeFilter(out VARIANT pvarTimeFilter);
  /*[id(0x00000013)]*/ int put_timeContainer(VARIANT pvarTimeContainer);
  /*[id(0x00000013)]*/ int get_timeContainer(out VARIANT pvarTimeContainer);
  /*[id(0x00000014)]*/ int put_timeAction(VARIANT pvarTimeAction);
  /*[id(0x00000014)]*/ int get_timeAction(out VARIANT pvarTimeAction);
  /*[id(0x00000015)]*/ int put_endHold(VARIANT pvarEndHold);
  /*[id(0x00000015)]*/ int get_endHold(out VARIANT pvarEndHold);
  /*[id(0x00000016)]*/ int put_repeat(VARIANT pvarRepeat);
  /*[id(0x00000016)]*/ int get_repeat(out VARIANT pvarRepeat);
  /*[id(0x00000018)]*/ int put_localTime(VARIANT pvarLocalTime);
  /*[id(0x00000018)]*/ int get_localTime(out VARIANT pvarLocalTime);
  /*[id(0x00000019)]*/ int get_timedParent(out VARIANT pvarTimedParent);
  /*[id(0x0000001A)]*/ int get_timedChildren(out VARIANT pvarTimedChildren);
  /*[id(0x0000001B)]*/ int beginElement(VARIANT varOffset);
  /*[id(0x0000001C)]*/ int endElement(VARIANT varOffset);
  /*[id(0x0000001D)]*/ int pauseElement();
  /*[id(0x0000001E)]*/ int resumeElement();
  /*[id(0x0000001F)]*/ int next();
  /*[id(0x00000020)]*/ int previous();
  /*[id(0x00000021)]*/ int put_iterateType(VARIANT pvarIterateType);
  /*[id(0x00000021)]*/ int get_iterateType(out VARIANT pvarIterateType);
  /*[id(0x00000022)]*/ int put_iterateInterval(VARIANT pvarIterateInterval);
  /*[id(0x00000022)]*/ int get_iterateInterval(out VARIANT pvarIterateInterval);
  /*[id(0x00000023)]*/ int put_iterateDirection(VARIANT pvarIterateDirection);
  /*[id(0x00000023)]*/ int get_iterateDirection(out VARIANT pvarIterateDirection);
  /*[id(0x00000024)]*/ int get_iterateCount(out VARIANT pvarIterateCount);
  /*[id(0x00000025)]*/ int put_targetElement(VARIANT pvarTargetElement);
  /*[id(0x00000025)]*/ int get_targetElement(out VARIANT pvarTargetElement);
}

// IIterateDHTMLBehaviorInternal Interface
interface IIterateDHTMLBehaviorInternal : IUnknown {
  mixin(uuid("9eecf672-d5e2-11d3-a4ca-00c04f6843fb"));
  /*[id(0x60010000)]*/ int IsIterate(out VARIANT pvarIsIterate);
  /*[id(0x60010001)]*/ int GetTargetArray(out VARIANT pvarTargetArray);
  /*[id(0x60010002)]*/ int GetTargetElement(out VARIANT pvarTargetElement);
}

// ICommandDHTMLBehavior Interface
interface ICommandDHTMLBehavior : IDispatch {
  mixin(uuid("5dc20346-0a84-11d4-a4ee-00c04f6843fb"));
  /*[id(0x00000002)]*/ int put_type(VARIANT pvarType);
  /*[id(0x00000002)]*/ int get_type(out VARIANT pvarType);
  /*[id(0x00000003)]*/ int put_cmd(VARIANT pvarCmd);
  /*[id(0x00000003)]*/ int get_cmd(out VARIANT pvarCmd);
  /*[id(0x00000004)]*/ int put_targetElement(VARIANT pvarTarget);
  /*[id(0x00000004)]*/ int get_targetElement(out VARIANT pvarTarget);
  /*[id(0x00000005)]*/ int put_runtimeContext(VARIANT pvarContext);
  /*[id(0x00000005)]*/ int get_runtimeContext(out VARIANT pvarContext);
}

// IIEEventListenerProxy Interface
interface IIEEventListenerProxy : IDispatch {
  mixin(uuid("1a556da8-781c-11d3-a490-00c04f6843fb"));
}

// IIEPropertyListenerProxy Interface
interface IIEPropertyListenerProxy : IDispatch {
  mixin(uuid("1a556dab-781c-11d3-a490-00c04f6843fb"));
}

// IOAVMediaDHTMLBehavior Interface
interface IOAVMediaDHTMLBehavior : IDispatch {
  mixin(uuid("3408c280-eaea-11d3-a4dc-00c04f6843fb"));
  /*[id(0x00000002)]*/ int put_volume(VARIANT pvarVolume);
  /*[id(0x00000002)]*/ int get_volume(out VARIANT pvarVolume);
  /*[id(0x00000003)]*/ int put_mute(VARIANT pvarMute);
  /*[id(0x00000003)]*/ int get_mute(out VARIANT pvarMute);
  /*[id(0x00000004)]*/ int put_clipBegin(VARIANT pvarClipBegin);
  /*[id(0x00000004)]*/ int get_clipBegin(out VARIANT pvarClipBegin);
  /*[id(0x00000005)]*/ int put_clipEnd(VARIANT pvarClipEnd);
  /*[id(0x00000005)]*/ int get_clipEnd(out VARIANT pvarClipEnd);
  /*[id(0x00000006)]*/ int put_src(VARIANT pvarSrc);
  /*[id(0x00000006)]*/ int get_src(out VARIANT pvarSrc);
  /*[id(0x00000007)]*/ int put_alt(VARIANT pvarAlt);
  /*[id(0x00000007)]*/ int get_alt(out VARIANT pvarAlt);
  /*[id(0x00000008)]*/ int put_targetElement(VARIANT pvarTarget);
  /*[id(0x00000008)]*/ int get_targetElement(out VARIANT pvarTarget);
  /*[id(0x00000009)]*/ int put_hideWhenStopped(VARIANT pvarHideWhenStopped);
  /*[id(0x00000009)]*/ int get_hideWhenStopped(out VARIANT pvarHideWhenStopped);
  /*[id(0x0000000A)]*/ int put_runtimeContext(VARIANT pvarContext);
  /*[id(0x0000000A)]*/ int get_runtimeContext(out VARIANT pvarContext);
  /*[id(0x0000000B)]*/ int play();
  /*[id(0x0000000C)]*/ int stop();
  /*[id(0x0000000D)]*/ int pause();
  /*[id(0x0000000E)]*/ int togglePause();
  /*[id(0x0000000F)]*/ int resume();
  /*[id(0x00000010)]*/ int playFrom(VARIANT varTime);
}

// IOAVIEClock Interface
interface IOAVIEClock : IUnknown {
  mixin(uuid("b1a3692d-eafb-11d3-a4dc-00c04f6843fb"));
}

// IOAVDShowPlayer Interface
interface IOAVDShowPlayer : IUnknown {
  mixin(uuid("3fda5dc1-ece0-11d3-9c20-00c04f72dd5f"));
  /*[id(0x60010000)]*/ int InitializeElementAfterDownload();
}

// IOAVRedirect Interface
interface IOAVRedirect : IDXEffect {
  mixin(uuid("eafb3627-ed6e-11d3-ba3b-00c04f6843fa"));
  /*[id(0x00000002)]*/ int get__OAVfilter(out IDispatch ppdispFilter);
  /*[id(0x00000003)]*/ int put_type(wchar* pbstrType);
  /*[id(0x00000003)]*/ int get_type(out wchar* pbstrType);
}

// IDXEffect Interface
interface IDXEffect : IDispatch {
  mixin(uuid("e31fb81b-1335-11d1-8189-0000f87557db"));
  /*[id(0x00002710)]*/ int get_Capabilities(out int pVal);
  /*[id(0x00002711)]*/ int get_progress(out float pVal);
  /*[id(0x00002711)]*/ int put_progress(float pVal);
  /*[id(0x00002712)]*/ int get_StepResolution(out float pVal);
  /*[id(0x00002713)]*/ int get_Duration(out float pVal);
  /*[id(0x00002713)]*/ int put_Duration(float pVal);
}

// IOAVRedirectFallback Interface
interface IOAVRedirectFallback : IDispatch {
  mixin(uuid("999937bb-30fe-11d4-ba52-00c04f6843fa"));
  /*[id(0x00000002)]*/ int get__OAVfilter(out IDispatch ppdispFilter);
}

// IOAVEmpty Interface
interface IOAVEmpty : IDispatch {
  mixin(uuid("98e2f336-ee36-11d3-ba3c-00c04f6843fa"));
}

// CoClasses

// IEHTMLElementCollection Class
abstract final class IEHTMLElementCollection {
  mixin(uuid("de5f419c-9e04-11d3-a4a0-00c04f6843fb"));
  mixin Interfaces!(IIEHTMLElementCollection);
}

// IETimeBehaviorFactory Class
abstract final class IETimeBehaviorFactory {
  mixin(uuid("a4639d29-774e-11d3-a490-00c04f6843fb"));
  mixin Interfaces!(IIETimeBehaviorFactory);
}

// IEAnimBehaviorFactory Class
abstract final class IEAnimBehaviorFactory {
  mixin(uuid("a4639d2f-774e-11d3-a490-00c04f6843fb"));
  mixin Interfaces!(IIEAnimBehaviorFactory);
}

// TimeExecutiveBehavior Class
abstract final class TimeExecutiveBehavior {
  mixin(uuid("a4639d33-774e-11d3-a490-00c04f6843fb"));
  mixin Interfaces!(ITimeExecutiveBehavior, ITimeExecutiveBehaviorInternal);
}

// AnimExecutiveBehavior Class
abstract final class AnimExecutiveBehavior {
  mixin(uuid("a4639d3f-774e-11d3-a490-00c04f6843fb"));
  mixin Interfaces!(IAnimExecutiveBehavior, IAnimExecutiveBehaviorInternal);
}

// AnimateDHTMLBehavior Class
abstract final class AnimateDHTMLBehavior {
  mixin(uuid("816ca828-8be4-11d3-a498-00c04f6843fb"));
  mixin Interfaces!(IAnimateDHTMLBehavior, IAnimTargetDHTMLBehaviorInternal);
}

// AnimColorDHTMLBehavior Class
abstract final class AnimColorDHTMLBehavior {
  mixin(uuid("816ca825-8be4-11d3-a498-00c04f6843fb"));
  mixin Interfaces!(IAnimColorDHTMLBehavior, IAnimTargetDHTMLBehaviorInternal);
}

// AnimFilterDHTMLBehavior Class
abstract final class AnimFilterDHTMLBehavior {
  mixin(uuid("816ca82a-8be4-11d3-a498-00c04f6843fb"));
  mixin Interfaces!(IAnimFilterDHTMLBehavior, IAnimTargetDHTMLBehaviorInternal);
}

// AnimMotionDHTMLBehavior Class
abstract final class AnimMotionDHTMLBehavior {
  mixin(uuid("816ca82c-8be4-11d3-a498-00c04f6843fb"));
  mixin Interfaces!(IAnimMotionDHTMLBehavior, IAnimTargetDHTMLBehaviorInternal);
}

// AnimRotationDHTMLBehavior Class
abstract final class AnimRotationDHTMLBehavior {
  mixin(uuid("816ca82e-8be4-11d3-a498-00c04f6843fb"));
  mixin Interfaces!(IAnimRotationDHTMLBehavior, IAnimTargetDHTMLBehaviorInternal);
}

// AnimScaleDHTMLBehavior Class
abstract final class AnimScaleDHTMLBehavior {
  mixin(uuid("816ca830-8be4-11d3-a498-00c04f6843fb"));
  mixin Interfaces!(IAnimScaleDHTMLBehavior, IAnimTargetDHTMLBehaviorInternal);
}

// AnimSetDHTMLBehavior Class
abstract final class AnimSetDHTMLBehavior {
  mixin(uuid("816ca832-8be4-11d3-a498-00c04f6843fb"));
  mixin Interfaces!(IAnimSetDHTMLBehavior, IAnimTargetDHTMLBehaviorInternal);
}

// AnimTargetDHTMLBehavior Class
abstract final class AnimTargetDHTMLBehavior {
  mixin(uuid("df2efcb5-917a-11d3-a49e-00c04f6843fb"));
  mixin Interfaces!(IAnimTargetDHTMLBehavior, IAnimTargetDHTMLBehaviorInternal);
}

// TimeDHTMLBehavior Class
abstract final class TimeDHTMLBehavior {
  mixin(uuid("a4639d41-774e-11d3-a490-00c04f6843fb"));
  mixin Interfaces!(ITimeDHTMLBehavior, ITimeDHTMLBehaviorInternal);
}

// IterateDHTMLBehavior Class
abstract final class IterateDHTMLBehavior {
  mixin(uuid("b96f84f7-d5ab-11d3-a4ca-00c04f6843fb"));
  mixin Interfaces!(IIterateDHTMLBehavior, ITimeDHTMLBehaviorInternal, IIterateDHTMLBehaviorInternal);
}

// CommandDHTMLBehavior Class
abstract final class CommandDHTMLBehavior {
  mixin(uuid("5dc20347-0a84-11d4-a4ee-00c04f6843fb"));
  mixin Interfaces!(ICommandDHTMLBehavior);
}

// IEEventListenerProxy Class
abstract final class IEEventListenerProxy {
  mixin(uuid("1a556daa-781c-11d3-a490-00c04f6843fb"));
  mixin Interfaces!(IIEEventListenerProxy);
}

// IEPropertyListenerProxy Class
abstract final class IEPropertyListenerProxy {
  mixin(uuid("1a556dac-781c-11d3-a490-00c04f6843fb"));
  mixin Interfaces!(IIEPropertyListenerProxy);
}

// OAVMediaDHTMLBehavior Class
abstract final class OAVMediaDHTMLBehavior {
  mixin(uuid("3408c281-eaea-11d3-a4dc-00c04f6843fb"));
  mixin Interfaces!(IOAVMediaDHTMLBehavior);
}

// OAVIEClock Class
abstract final class OAVIEClock {
  mixin(uuid("b1a3692e-eafb-11d3-a4dc-00c04f6843fb"));
  mixin Interfaces!(IOAVIEClock);
}

// OAVDShowPlayer Class
abstract final class OAVDShowPlayer {
  mixin(uuid("3fda5dc2-ece0-11d3-9c20-00c04f72dd5f"));
  mixin Interfaces!(IOAVDShowPlayer);
}

// OAVRedirect Class
abstract final class OAVRedirect {
  mixin(uuid("eafb3628-ed6e-11d3-ba3b-00c04f6843fa"));
  mixin Interfaces!(IOAVRedirect);
}

// OAVRedirectFallback Class
abstract final class OAVRedirectFallback {
  mixin(uuid("999937bc-30fe-11d4-ba52-00c04f6843fa"));
  mixin Interfaces!(IOAVRedirectFallback);
}

// OAVEmpty Class
abstract final class OAVEmpty {
  mixin(uuid("98e2f337-ee36-11d3-ba3c-00c04f6843fa"));
  mixin Interfaces!(IOAVEmpty);
}
