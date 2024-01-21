import Button from "./components/ui/Button";
import RaffleCard from "./components/ui/RaffleCard";

export default function App() {
  return (
    <main className="p-0 m-0 flex flex-col justify-between items-center mt-8 gap-6 box-border">
      <h1 className="text-3xl">FairDraw : A  fair decentralized raffle system</h1>
      <Button buttonText="Enter The Raffle" />
      <h2 className="font-semibold text-gray-600"> **Please note that mininimun entry fee is : 0.1 ETH</h2>
      <RaffleCard />
    </main>
  );
}
