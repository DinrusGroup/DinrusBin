/** \mainpage  Concurrent library for D
 * 
 * This is a port of Doug Lea's concurrent Java library to D. It
 * contains basic sychronization constructs that extend the
 * builtin D "synchronized" statement. <br>
 *
 * For more information about D see http://www.digitalmars.com/d
 * and for Doug Lea's Java implementation see 
 * http://gee.cs.oswego.edu/dl/классы/EDU/oswego/cs/dl/util/concurrent/intro.html
 */

module conc.all;
pragma(lib, "DinrusConc.lib");

// Java жди/уведоми and жди/уведомиВсех support
public import conc.waitnotify;

// Синх support
public import conc.sync;
public import conc.semaphore;
public import conc.mutex;
public import conc.fairsemaphore;
public import conc.queuedsemaphore;
public import conc.fifosemaphore;
public import conc.reentrantlock;
public import conc.latch;
public import conc.countdown;

// Барьер support
public import conc.barrier;
public import conc.cyclicbarrier;
public import conc.rendezvous;

// Канал support
public import conc.boundedchannel;
public import conc.boundedlinkedqueue;
public import conc.channel;
public import conc.linkednode;
public import conc.linkedqueue;
public import conc.puttable;
public import conc.takable;
public import conc.synchronouschannel;

// Исполнитель support
public import conc.directexecutor;
public import conc.executor;
public import conc.queuedexecutor;
public import conc.lockedexecutor;
public import conc.pooledexecutor;
public import conc.threadedexecutor;
public import conc.threadfactory;
public import conc.threadfactoryuser;

// Read/Write Locks
public import conc.readwritelock;
public import conc.readwritelockutils;

