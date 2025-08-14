import Header from '../Components/Header'
import CategoryForm from '../Components/CategoryFormNew'

const Categories = () => {
  return (
    <>
    <Header />
    <div className='bg-white w-[95%] min-h-[600px] flex flex-col items-center rounded-lg shadow-lg mx-auto mt-[100px] md:mt-10 p-6'>
     <div className='flex flex-col items-center justify-center mt-10 w-full'>
     <h1 className='text-2xl font-bold mb-6'>Categorías</h1>
        <div className='flex items-center justify-center w-full'>
            <CategoryForm/>
        </div>
     </div>
    </div>
    </>
  )
}

export default Categories