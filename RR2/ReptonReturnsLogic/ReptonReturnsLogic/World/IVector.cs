namespace ReptonReturnsLogic.World
{
    public interface IVector
    {
        public int Up { get; }
        public int Down { get; }

        void Add(IVector addition);

        //public operator +(IVector m1, IVector m2);
    }
}
