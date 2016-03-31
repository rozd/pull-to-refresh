/**
 * Created by Max Rozdobudko on 5/12/15.
 */
package feathers.examples.todos
{
public class ClassUtil
{
    public static function compare(instance1:Object, instance2:Object):Boolean
    {
        trace(Object(instance1).constructor);

        return instance2 is instance1.constructor || instance1 is instance2.constructor;
    }
}
}
