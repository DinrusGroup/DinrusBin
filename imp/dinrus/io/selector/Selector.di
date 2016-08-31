module io.selector.Selector;

version (linux)
{
    public import io.selector.EpollSelector;

    alias EpollSelector Селектор;
}
else version(Posix)
{
    public import io.selector.PollSelector;

    alias PollSelector Селектор;
}
else
{
    public import io.selector.SelectSelector;

    alias СелекторВыбора Селектор;
}
