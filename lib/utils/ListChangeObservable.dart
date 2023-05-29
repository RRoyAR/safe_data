typedef listChange<T> = void Function(List<T> list);

class ListChangeObservable<T>
{
	List<listChange<T>> listeners = List<listChange<T>>();

    addListener(listChange<T> listener) => listeners.add(listener);

    removeListener(listChange<T> listener) => listeners.remove(listener);
    
    notifyAll(List<T> changedList)
    {
        for (listChange<T> currentlistener in listeners) 
        {
            currentlistener(changedList);
        }
    }
}
